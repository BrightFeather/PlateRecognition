# PlateRecognition

- Matlab code for chinese automobile plate recognition 

- by Weijia Chen (BrightFeather)

### Preparation
	
1. Download the whole repository by typing into terminal 
`git clone https://github.com/BrightFeather/PlateRecognition.git` or download zip

2. Open matlab and set the downloaded repository as current
	
3. Type and run `set up` in matlab command line（This sets up the vlfeat environment for character recognition. Runs well under MacOS and Linux, might have trouble with Windows. Troubleshooting: http://www.vlfeat.org/install-matlab.html）

### Plate Recognition

Type into matlab command line 
 
 `tellPlate(*image name*)`
 
  Sample images can be found in repository *testset*. 
  
Examples:

```
tellPlate('testset/京A82806.jpg')
tellPlate('testset/easytest/1.jpg')
```

Questions and bugs, please email me at chensir1994@gmail.com



