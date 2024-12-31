godot-src: Contains the godot project
dist: final game export
public/godot-export: temporary export destination
src: Other JS/Client logic
 
Set the correct godot path in package.json
    For mac it is: /Applications/Godot.app/Contents/MacOS/Godot



### Summary

- **

speechRecognizer.js

**: Used in 

comms.gd

.
- **`azureTTS.js`**: Used in 

http_request.gd

.
- **

conversation.js

**: Used in 

http_request.gd

.
- **`logging.js`**: Used in 

http_request.gd

.
- **`visemeMaps.js`**: Used in 

viseme.gd

.
- **

conversation.js

**: Used in 

viseme.gd

.

This grouping shows how the `JavaScriptBridge` is used in various Godot scripts to interact with the JavaScript files in the 

src

 directory.