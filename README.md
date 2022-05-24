# Serial_Processing
Collection of classes for run time configuring of comm ports in Processing with use case example.

Read "Processing Serial Port routines.docx" for usage. <BR>Tested to work with Processing 3_5_3 and 4_0B8 on W10 64bit. Some attempt started for Linux (Comm port name differences and detecting Windows/Linux)<BR><BR> Requires G4P and Console libraries accessible from Processing IDE Sketch>>Import Library>>Manage Libraries.<BR><BR>
Note 4_08B has a message on the console MOVE X and Y position when the launch window is moved. This is not something I am activly doing in code, either a bug in the beta or an option I need to turn off. Has no impact on the program or the generated log files. 

![image](https://user-images.githubusercontent.com/5317221/168467824-481251d2-5416-43d3-85d8-d551f4b5f918.png)

Thanks to Quarks http://www.lagers.org.uk/g4p/index.html for such a clean GUI Library for Processing<br>
Thanks to https://tinylog.org/v2/ for such a KISS logging tool.<br>
Then of course Processing https://processing.org.
  <BR><BR>
    __TODO__<BR>
    Add text box to launch gui for file name saved and indicate if opened for logging.<BR>
    Add text box to launch for string to send with Send button.
    Add option to add date time group with comma for CSV to logs and Console for each process.
