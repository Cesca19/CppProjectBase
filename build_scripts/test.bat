@echo off
REM --- Mise à jour de pip et installation de conan ---
python -m pip install --upgrade pip
python -m pip install conan --user

REM --- Récupération du dossier Scripts de Python ---
for /f "delims=" %%i in ('python -c "import site, os; print(os.path.join(site.USER_BASE, 'Scripts'))"') do set CONAN_SCRIPTS=%%i

REM --- Ajout temporaire au PATH ---
set PATH=%CONAN_SCRIPTS%;%PATH%

REM --- Vérification ---
echo PATH mis à jour: %CONAN_SCRIPTS%
conan --version

pause

