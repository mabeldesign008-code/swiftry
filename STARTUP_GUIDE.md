# Yendrop Startup Guide (Web & ngrok)

When starting the development server to preview the Flutter app on a mobile device via ngrok, **do not** use `flutter run -d web-server`. The Dart Development Compiler (DDC) causes 404 errors (like `dart_sdk.js`) when accessed through an ngrok tunnel.

Instead, follow this 3-step workflow to serve a compiled version of the app statically using Python:

### Step 1: Build the Web App
Run the Flutter web build process to generate static files:
```powershell
C:\Users\Eddie\Desktop\app\flutter\bin\flutter.bat build web
```
*(Wait for this process to complete successfully.)*

### Step 2: Start the Python HTTP Server
Navigate to the build directory and start a local static server on port 8080:
```powershell
cd build\web
python -m http.server 8080
```
*(Leave this running in the background.)*

### Step 3: Expose via ngrok
Start ngrok pointing to port 8080 using the stable domain and the rewrite flag to ensure assets load correctly:
```powershell
C:\ngrok\ngrok.exe http --domain=moral-subtle-stallion.ngrok-free.app 8080 --host-header=rewrite
```
*(Leave this running in the background.)*

### Summary for AI Agents
If asked to "start the app", execute the above 3 steps sequentially using background tasks. Wait for Step 1 to finish before executing Steps 2 and 3 concurrently.
