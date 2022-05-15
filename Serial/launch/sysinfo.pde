/**
 * <H1>System Info relavant to Processing</H1>
 * Copyright (c) [2022] [Stefan Morley]
 * @author SBM
 * @version 0_2_1
 * MIT Licence attached
*/

class sysinfo extends PApplet
{
  
@SuppressWarnings("unused")  
private PApplet app;  

// Note sysinfo(PApplet app) can only be called from first layer class.
// Otherwise one needs to call sysinfo(String my_path) with my_path being derived from sketchPath() from that first layer class.

public sysinfo(PApplet app)
{
  this.app = app;
  system_info();
  Logger.info( "sketchPath : " + app.sketchPath() );
  Logger.info( "dataPath   : " + app.dataPath("") );
  Logger.info( "dataFile   : " + app.dataFile("") ); 
  Logger.info( "canvas     : width " + app.width + " height " + app.height + " pix " + (app.width * app.height));   
}

public sysinfo(float x_width, float y_height, String my_path)
{
  //print_system();
  system_info();
  Logger.info( "sketchPath : " + my_path );
  Logger.info( "dataPath   : " + my_path + "\\data");
  Logger.info( "dataFile   : " + my_path + "\\data");  
  Logger.info( "canvas     : width " + x_width + " height " + y_height + " pix " + (x_width * y_height)); 
}

private void system_info()
{
  Logger.info( "Processing SYS INFO :");
  Logger.info( "System     : " + System.getProperty("os.name") + "  " + System.getProperty("os.version") + "  " + System.getProperty("os.arch") );
  Logger.info( "JAVA       : " + System.getProperty("java.home")  + " rev: " +javaVersionName);
  Logger.info( "OPENGL     : VENDOR " + PGraphicsOpenGL.OPENGL_VENDOR+" RENDERER " + PGraphicsOpenGL.OPENGL_RENDERER+" VERSION " + PGraphicsOpenGL.OPENGL_VERSION+" GLSL_VERSION: " + PGraphicsOpenGL.GLSL_VERSION);
  Logger.info( "user.home  : " + System.getProperty("user.home") );
  Logger.info( "user.dir   : " + System.getProperty("user.dir") );
  Logger.info( "user.name  : " + System.getProperty("user.name") );
  Logger.info( "frameRate  :  actual " + nf(frameRate, 0, 1));   
}
}
