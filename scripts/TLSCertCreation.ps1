. 'C:\vagrant\scripts\Globals.ps1'
# Create Certs folder under C drive
if (!(Test-Path $ServerCertFolder -PathType Container)) {
  New-Item -Path $ServerCertFolder -ItemType Directory
}

# Overwrite v3.ext and ykf.cnf 
(Get-Content -Path "$RootCertPath\ykf.cnf" -Raw) -replace 'THE_FQDN', $CertName | Set-Content -Path "$RootCertPath\ykf.cnf"
(Get-Content -Path "$RootCertPath\v3.ext" -Raw) -replace 'THE_FQDN', $CertName | Set-Content -Path "$RootCertPath\v3.ext"

# Generate cert based on CertName
openssl genrsa -out "$ServerCertFolder\tlsServerKey.pem" 2048

openssl req -new -key "$ServerCertFolder\tlsServerKey.pem" -sha256 -out "$ServerCertFolder\tlsServerCert.csr" -config "$RootCertPath\ykf.cnf"

openssl x509 -req -sha256 -in "$ServerCertFolder\tlsServerCert.csr" -CA "$RootCertPath\atca.pem" -CAkey "$RootCertPath\atcaKey.pem" -CAcreateserial -out "$ServerCertFolder\$CertName.pem" -days 825 -extfile "$RootCertPath\v3.ext"

openssl pkcs12 -export -out "$ServerCertFolder\$CertName.p12" -in "$ServerCertFolder\$CertName.pem" -inkey "$ServerCertFolder\tlsServerKey.pem" -passout pass:221printeron
