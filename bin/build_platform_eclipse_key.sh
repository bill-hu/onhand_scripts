#!/bin/bash
destdir=eclipse_key
if [ ! -d $destdir ]
then
   mkdir $destdir
fi
declare -a keys
keysrcdir="build/target/product/security/"
keys=("media" "platform" "shared")
echo ${#keys[@]}

for key in ${keys[@]};do
 echo $key
 pk8=$key".pk8"
 pem=$key".x509.pem"
 cp $keysrcdir$pk8 $destdir/$pk8
 cp $keysrcdir$pem $destdir/$pem
done

cd $destdir

for key in ${keys[@]};do
 pk8=$key".pk8"
 pem=$key".x509.pem"
 openssl pkcs8 -in $pk8 -inform DER -outform PEM -out $key.priv.pem -nocrypt
 openssl pkcs12 -export -in $pem -inkey $key.priv.pem -out $key.pk12 -name androiddebugkey
 keytool -importkeystore -deststorepass android -destkeypass android -destkeystore $key.debug.keystore -srckeystore $key.pk12 -srcstoretype PKCS12 -srcstorepass android -alias androiddebugkey
done


