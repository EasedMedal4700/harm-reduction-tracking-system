& C:\Users\USER\dev\code\mobile_drug_use_app\.venv\Scripts\Activate.ps1
cd C:\Users\USER\dev\code\mobile_drug_use_app

python scripts/ci/tui.py

flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

& .\venv\Scripts\Activate.ps1