import java.util.Locale;
import org.pmw.tinylog.Configurator;
import org.pmw.tinylog.Level;

enum LOGGER
{
  NO_LOGGER,
  FILE_LOGGER,
  CONSOLE_LOGGER
}

public void change_logger_output(LOGGER log)
{
  if(log == LOGGER.FILE_LOGGER)
  {
  Configurator.currentConfig()  
  .writer(new org.pmw.tinylog.writers.FileWriter(sketchPath("/data/log.txt")))
  .activate();
  }  
  if(log == LOGGER.CONSOLE_LOGGER)
  {
  Configurator.currentConfig()  
  .writer(new ConsoleWriter())
  .activate();
  }
}

public void change_logger_level(Level level)
{
  Configurator.currentConfig()
  .level(level)
  .activate();
}

public void configure_logger()
{   
Configurator.currentConfig()
   .writer(new org.pmw.tinylog.writers.FileWriter(sketchPath("/data/log.txt")))
   .formatPattern("{date:yyyy-MM-dd HH:mm:ss} {{level}|min-size=5} {class_name}.{method} - {message}")   
   .level(Level.INFO)
   .locale(Locale.US)
   .activate();    
}

public void version_info()
{
  Logger.info("************************************");
  Logger.info("Application Launched");
  Logger.info("Serial Configuration Version = " + Serial_Config_Version); 
}
