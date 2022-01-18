# Dog Project

## Variables
### image
User input image
### imagePicker
Image Picker object
### predOne
Breed prediction with highest confidence
### predOneConf
Breed prediction confidence

## Functions
### initState()
Function used to initialize the Home Page state. This function also calls `loadTfliteModel`.

### loadTfliteModel()
Function used to load the asset model. This function utilizes the Tflite plugin.

### getImageFromGallery()
Function used to get an image from the user's gallery. This function also calls `getOutputs`.

### getImageFromCamera()
Function used to get an image from the user's camera. This function also calls `getOutputs`.

### getOutputs()
Function used to pass the user's input image to the trained model. This function also sets the state for variables predOne and predOneConf allowing the user's interface to change according to the output results.

### resetVar()
Function used to reset variables to get ready for another input if the user so chooses.
