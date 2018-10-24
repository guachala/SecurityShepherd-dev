@echo off
REM ###########################################################################
REM Script generated by Fortify SCA Scan Wizard (c) 2011-2018 Micro Focus or one of its affiliates
REM Created on 2018/10/23 18:50:42
REM ###########################################################################
REM Generated for the following languages:
REM 	HTML
REM 	Java
REM 	Java Bytecode
REM 	Javascript
REM 	JSP J2EE
REM 	SQL
REM 	XML
REM ###########################################################################
REM DEBUG - if set to true, runs SCA in debug mode
REM SOURCEANALYZER - the name of the SCA executable
REM FPR - the name of analysis result file
REM BUILDID - the SCA build id
REM ARGFILE - the name of the argument file that's extracted and passed to SCA
REM BYTECODE_ARGFILE - the name of the argument file for Java Bytecode translation that's extracted and passed to SCA
REM MEMORY - the memory settings for SCA
REM LAUNCHERSWITCHES - the launcher settings that are used to invoke SCA
REM OLDFILENUMBER - this defines the file which contains the number of files within the project, it is automatically generated
REM FILENOMAXDIFF - this is the percentage of difference between the number of files which will trigger a warning by the script
REM ###########################################################################

set DEBUG=false
set SOURCEANALYZER=sourceanalyzer
set FPR="FortifySecurityShepherd-dev.fpr"
set BUILDID="SecurityShepherd-dev"
set ARGFILE="FortifySecurityShepherd-dev.bat.args"
set BYTECODE_ARGFILE="FortifySecurityShepherd-dev.bat.bytecode.args"
set MEMORY=-Xmx2654M -Xms400M -Xss24M 
set LAUNCHERSWITCHES=""
set OLDFILENUMBER=FortifySecurityShepherd-dev.bat.fileno
set FILENOMAXDIFF=10
set ENABLE_BYTECODE=false

set PROJECTROOT0="C:\Users\w372\Desktop\instalaveis\SecurityShepherd-dev"
IF NOT EXIST %PROJECTROOT0% (
   ECHO  ERROR: This script is being run on a different machine than it was
   ECHO         generated on or the targeted project has been moved. This script is 
   ECHO         configured to locate files at
   ECHO            %PROJECTROOT0%
   ECHO         Please modify the %%PROJECTROOT0%% variable found
   ECHO         at the top of this script to point to the corresponding directory
   ECHO         located on this machine.
   GOTO :FINISHED
)

IF %DEBUG%==true set LAUNCHERSWITCHES=-debug %LAUNCHERSWITCHES%
echo Extracting Arguments File


echo. >%ARGFILE%
echo. >%BYTECODE_ARGFILE%
SETLOCAL ENABLEDELAYEDEXPANSION
IF EXIST %0 (
   set SCAScriptFile=%0
) ELSE (
  set SCAScriptFile=%0.bat
)

set PROJECTROOT0=%PROJECTROOT0:)=^)%
FOR /f "delims=" %%a IN ('findstr /B /C:"REM ARGS" %SCAScriptFile%' ) DO (
   set argVal=%%a
   set argVal=!argVal:PROJECTROOT0_MARKER=%PROJECTROOT0:~1,-1%!
   echo !argVal:~9! >> %ARGFILE%
)
set PROJECTROOT0=%PROJECTROOT0:)=^)%
FOR /f "delims=" %%a IN ('findstr /B /C:"REM BYTECODE_ARGS" %SCAScriptFile%' ) DO (
   set ENABLE_BYTECODE=true
   set argVal=%%a
   set argVal=!argVal:PROJECTROOT0_MARKER=%PROJECTROOT0:~1,-1%!
   echo !argVal:~18! >> %BYTECODE_ARGFILE%
)
ENDLOCAL && set ENABLE_BYTECODE=%ENABLE_BYTECODE%

REM ###########################################################################
echo Cleaning previous scan artifacts
%SOURCEANALYZER% %MEMORY% %LAUNCHERSWITCHES% -b %BUILDID% -clean 
IF %ERRORLEVEL%==1 (
echo Sourceanalyzer failed, exiting
GOTO :FINISHED
)
REM ###########################################################################
echo Translating files
%SOURCEANALYZER% %MEMORY% %LAUNCHERSWITCHES% -b %BUILDID% @%ARGFILE%
IF %ERRORLEVEL%==1 (
echo Sourceanalyzer failed, exiting
GOTO :FINISHED
)
REM ###########################################################################
IF %ENABLE_BYTECODE%==true (
echo Translating Java bytecode files
%SOURCEANALYZER% %MEMORY% %LAUNCHERSWITCHES% -b %BUILDID% @%BYTECODE_ARGFILE%
IF %ERRORLEVEL%==1 (
echo Sourceanalyzer failed, exiting
GOTO :FINISHED
)
)
REM ###########################################################################
echo Testing Difference between Translations
SETLOCAL
FOR /F "delims=" %%A in ('%SOURCEANALYZER% -b %BUILDID% -show-files ^| findstr /R /N "^" ^| find /C ":" ') DO SET FILENUMBER=%%A
IF NOT EXIST %OLDFILENUMBER% (
	ECHO It appears to be the first time running this script, setting %OLDFILENUMBER% to %FILENUMBER%
	ECHO %FILENUMBER% > %OLDFILENUMBER%
	GOTO TESTENDED
)

FOR /F "delims=" %%i IN (%OLDFILENUMBER%) DO SET OLDFILENO=%%i
set /a DIFF=%OLDFILENO% * %FILENOMAXDIFF%
set /a DIFF /=  100
set /a MAX=%OLDFILENO% + %DIFF%
set /a MIN=%OLDFILENO% - %DIFF%

IF %FILENUMBER% LSS %MIN% set SHOWWARNING=true
IF %FILENUMBER% GTR %MAX% set SHOWWARNING=true

IF DEFINED SHOWWARNING (
	ECHO WARNING: The number of files has changed by over %FILENOMAXDIFF%%%, it is recommended 
	ECHO          that this script is regenerated with the ScanWizard
)
:TESTENDED
ENDLOCAL

REM ###########################################################################
echo Starting scan
%SOURCEANALYZER% %MEMORY% %LAUNCHERSWITCHES% -b %BUILDID% -scan -f %FPR%
IF %ERRORLEVEL%==1 (
echo Sourceanalyzer failed, exiting
GOTO :FINISHED
)
REM ###########################################################################
echo Finished
:FINISHED
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\MobileShepherd\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\exploded-aar\com.android.support\support-v4\21.0.3\jars\classes.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UDataLeakage2\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsecureData2\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsufficientTLS2\libs\android-support-v4.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\InsufficientTLS\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UDataLeakage1\app\libs\robotium-solo-5.3.1.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\pre-dexed\release\support-annotations-21.0.3_a744aa363a70a5e75185477085f408ec0de66d12.jar;PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto1\gradle\wrapper\gradle-wrapper.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\InsecureData1\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication2\app\libs\robotium-solo-5.3.1.jar;PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto3\app\libs\sqlcipher.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection1\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UntrustedInput\gradle\wrapper\gradle-wrapper.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto2\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection1\app\libs\sqlcipher.jar;PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication\app\libs\robotium-solo-5.3.1.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection\app\libs\robotium-solo-5.3.1.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection1\app\libs\sqlcipher-javadoc.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsecureData3\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\exploded-aar\com.android.support\support-v4\21.0.3\jars\libs\internal_impl-21.0.3.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication2\app\libs\sqlcipher.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection2\app\libs\sqlcipher.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection2\app\libs\sqlcipher-javadoc.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\pre-dexed\release\com.android.support-support-v4-21.0.3_dd09934371e179199b1c0f60da091b0716d7104c.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CProviderLeakage1\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UDataLeakage\app\libs\robotium-solo-5.3.1.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication2\app\libs\sqlcipher-javadoc.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection\app\libs\sqlcipher-javadoc.jar;PROJECTROOT0_MARKER\src\MobileShepherd\SessionManagement\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CProviderLeakage\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer2\gradle\wrapper\gradle-wrapper.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto3\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\pre-dexed\release\com.android.support-appcompat-v7-21.0.3_9c559508745511990f7c0983fe6bd68e8ba73f80.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\pre-dexed\release\internal_impl-21.0.3_5f86d92f0d11450dbaa76b9870bf4fc0d911059e.jar;PROJECTROOT0_MARKER\src\MobileShepherd\WeakServerSideControls\gradle\wrapper\gradle-wrapper.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication1\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ShepherdLogin\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection2\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsecureData\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer1\gradle\wrapper\gradle-wrapper.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection\app\libs\sqlcipher.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UDataLeakage1\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication2\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UDataLeakage\gradle\wrapper\gradle-wrapper.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\MobShepTemplate\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\exploded-aar\com.android.support\appcompat-v7\21.0.3\jars\classes.jar;PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto3\app\libs\sqlcipher-javadoc.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsufficientTLS\app\libs\org.apache.http.legacy.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsufficientTLS2\gradle\wrapper\gradle-wrapper.jar"
REM ARGS "-cp"
REM ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\pre-dexed\release\release_18b24037ba5aa77bebb42078b56a4ba2fdd467c1.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ShepherdResolver\gradle\wrapper\gradle-wrapper.jar"
REM ARGS "-source"
REM ARGS "1.8"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\MobileShepherd\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\exploded-aar\com.android.support\support-v4\21.0.3\jars\classes.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UDataLeakage2\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsecureData2\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsufficientTLS2\libs\android-support-v4.jar"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\InsufficientTLS\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UDataLeakage1\app\libs\robotium-solo-5.3.1.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\pre-dexed\release\support-annotations-21.0.3_a744aa363a70a5e75185477085f408ec0de66d12.jar;PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto1\gradle\wrapper\gradle-wrapper.jar"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\InsecureData1\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication2\app\libs\robotium-solo-5.3.1.jar;PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto3\app\libs\sqlcipher.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection1\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UntrustedInput\gradle\wrapper\gradle-wrapper.jar"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto2\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection1\app\libs\sqlcipher.jar;PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication\app\libs\robotium-solo-5.3.1.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection\app\libs\robotium-solo-5.3.1.jar"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection1\app\libs\sqlcipher-javadoc.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsecureData3\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\exploded-aar\com.android.support\support-v4\21.0.3\jars\libs\internal_impl-21.0.3.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication2\app\libs\sqlcipher.jar"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection2\app\libs\sqlcipher.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection2\app\libs\sqlcipher-javadoc.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\pre-dexed\release\com.android.support-support-v4-21.0.3_dd09934371e179199b1c0f60da091b0716d7104c.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CProviderLeakage1\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UDataLeakage\app\libs\robotium-solo-5.3.1.jar"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication2\app\libs\sqlcipher-javadoc.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection\app\libs\sqlcipher-javadoc.jar;PROJECTROOT0_MARKER\src\MobileShepherd\SessionManagement\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CProviderLeakage\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer2\gradle\wrapper\gradle-wrapper.jar"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto3\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\pre-dexed\release\com.android.support-appcompat-v7-21.0.3_9c559508745511990f7c0983fe6bd68e8ba73f80.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\pre-dexed\release\internal_impl-21.0.3_5f86d92f0d11450dbaa76b9870bf4fc0d911059e.jar;PROJECTROOT0_MARKER\src\MobileShepherd\WeakServerSideControls\gradle\wrapper\gradle-wrapper.jar"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication1\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ShepherdLogin\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection2\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsecureData\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer1\gradle\wrapper\gradle-wrapper.jar"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\CSInjection\app\libs\sqlcipher.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UDataLeakage1\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\PoorAuthentication2\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\UDataLeakage\gradle\wrapper\gradle-wrapper.jar"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\MobShepTemplate\gradle\wrapper\gradle-wrapper.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\exploded-aar\com.android.support\appcompat-v7\21.0.3\jars\classes.jar;PROJECTROOT0_MARKER\src\MobileShepherd\BrokenCrypto3\app\libs\sqlcipher-javadoc.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsufficientTLS\app\libs\org.apache.http.legacy.jar;PROJECTROOT0_MARKER\src\MobileShepherd\InsufficientTLS2\gradle\wrapper\gradle-wrapper.jar"
REM BYTECODE_ARGS "-cp"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\src\MobileShepherd\ReverseEngineer3\app\build\intermediates\pre-dexed\release\release_18b24037ba5aa77bebb42078b56a4ba2fdd467c1.jar;PROJECTROOT0_MARKER\src\MobileShepherd\ShepherdResolver\gradle\wrapper\gradle-wrapper.jar"
REM BYTECODE_ARGS "-source"
REM BYTECODE_ARGS "1.5"
REM ARGS "-Dcom.fortify.sca.fileextensions.sql=PLSQL"
REM BYTECODE_ARGS "-Dcom.fortify.sca.fileextensions.class=BYTECODE"
REM BYTECODE_ARGS "-Dcom.fortify.sca.fileextensions.jar=ARCHIVE"
REM ARGS "PROJECTROOT0_MARKER"
REM BYTECODE_ARGS "PROJECTROOT0_MARKER\**\*.class" "PROJECTROOT0_MARKER\**\*.jar"
