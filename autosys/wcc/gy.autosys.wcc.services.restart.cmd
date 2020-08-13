REM PBV 2017-AUG-29
REM Dealing with WCC issues, requires restarts of CA WCC Windows Services
REM Wait until services "STOPPED" in the correct order before starting them

sc STOP "CA-wcc"
:is_stopped_wcc
timeout 5
sc QUERY "CA-wcc" | find "STOPPED"
if "%errorlevel%"=="0" (
  echo "CA-wcc" Process Stopped
) else (
  goto :is_stopped_wcc
)

sc STOP "CA-wcc-services"
:is_stopped_wcc_services
timeout 5
sc QUERY "CA-wcc-services" | find "STOPPED"
if "%errorlevel%"=="0" (
  echo "CA-wcc-services" Process Stopped
) else (
  goto :is_stopped_wcc_services
)

sc START "CA-wcc-services"
timeout 5
sc START "CA-wcc"
