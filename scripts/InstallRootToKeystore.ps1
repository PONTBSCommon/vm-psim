# Install the trusted Root into Java cacerts Keystore
. 'C:\vagrant\scripts\Globals.ps1'

Set-Location "$env:PON_JAVA_HOME\bin"

.\keytool -import -trustcacerts -keystore "$env:PON_JAVA_HOME\lib\security\cacerts" -alias atcaRoot -noprompt -storepass changeit -file "$ATCACerFile"