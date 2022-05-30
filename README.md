# Serial_Processing
Collection of classes for run time configuring of comm ports in Processing with use case example. See https://github.com/myupctoys/Serial_Processing_IntelliJ for the JAVA version.

Read "Processing Serial Port routines.docx" for usage. <BR>Tested to work with Processing 3_5_3 and 4_0B8 on W10 64bit. Some attempt started for Linux but by no means complete (Comm port name differences and detecting Windows/Linux)<BR><BR> Requires G4P and Console libraries accessible from Processing IDE Sketch>>Import Library>>Manage Libraries.<BR><BR>
Note 4_08B has a message on the console MOVE X and Y position when the launch window is moved. This is not something I am activly doing in code, either a bug in the beta or an option I need to turn off. Has no impact on the program or the generated log files. 
  
![image](https://user-images.githubusercontent.com/5317221/171067041-78e1672f-adc0-41e2-a0ff-f9c3822576da.png)

![image](https://user-images.githubusercontent.com/5317221/171066994-b4377a1d-4cf1-46e6-9e60-cbcf0ab51226.png)

  
Thanks to Quarks http://www.lagers.org.uk/g4p/index.html for such a clean GUI Library for Processing<br>
Thanks to https://tinylog.org/v2/ for such a KISS logging tool.<br>
Then of course Processing https://processing.org.
  <BR><BR>
    <b>TODO__</b><BR>
    <b>#1</b> Need to come up with a logical way of indicating which of four files is open.<BR>
    <b>#2</b> Add text box to launch for string to send with Send button. <b>DONE</b><BR>
    <b>#3</b> Add option to add date time group with comma for CSV to logs and Console for each process. <b>DONE</b><BR>
    <b>#4</b> Check all processes create and log to corresponding log file. <b>DONE</b><BR>
    <b>#5</b> Implement binary file transfers.<BR>
    <b>#6</b> Simple way of indicating which of 4 processes one might want to sent the text to.
