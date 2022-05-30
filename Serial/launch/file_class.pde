/**
 * <H1>File IO class</H1>
 * Simple class to deal with file load and save
 * Copyright (c) [2022] [Stefan Morley]
 * @author SBM
 * @version 0_2_1
 * MIT Licence attached
*/
 
import org.pmw.tinylog.Logger;
import java.io.*;

class file_class 
{
  private String new_file;

public file_class()
  {
  }

public file_class(String file_name)
  {
    setNew_file(file_name);
  }
  
public String get_new_file()
  {
    return new_file;
  }

  public void set_new_file(String new_file)
  {
    this.new_file = new_file;
  }  
  
public boolean is_file_exist(String file_name)
{
  File temp = new File(file_name);
  boolean exists = temp.exists();
  return exists;
}
  
public int countLines(String filename) throws IOException 
  {
      LineNumberReader reader  = new LineNumberReader(new FileReader(filename));
      int cnt = 0;
      @SuppressWarnings("unused")
    String lineRead = "";
    while ((lineRead = reader.readLine()) != null) {}
      cnt = reader.getLineNumber(); 
    reader.close();
  return cnt;
  }

    public void setNew_file(String file_name) 
    {
  new_file = file_name;
  }
    public String getNew_file() 
    {
  return new_file;
  }
    
    public boolean file_write(String data) 
    {
      return file_write(new_file, data, false);
    }
    
    public boolean file_append(String data) 
    {
      return file_write(new_file, data, true);
    }
        
    
    public String file_read() 
    {
      return file_read(new_file);
    }

    /**
     * <H1>Write to file</H1>
     * @param file_name String for file name 8.3 format
     * @param data Line you want to write to the file
     * @param flag Append to existing file or over write
     * @return
     */
    public boolean file_write(String file_name, String data, Boolean flag) 
    {
        // The name of the file to open.
        new_file = file_name;

        try 
        {
            // Assume default encoding.
            java.io.FileWriter fileWriter = new java.io.FileWriter(new_file, flag);

            // Always wrap FileWriter in BufferedWriter.
            BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);

            // Note that write() does not automatically
            // append a newline character.
            bufferedWriter.write(data);

            // Always close files.
            bufferedWriter.close();
            return true;
        }
        catch(IOException ex) 
        {
        Logger.info("Error Writing to file :- " + new_file);
        }
        return false;
    }
  
    public boolean file_close(BufferedWriter bufferedWriter)
    {
      boolean status = false;
      try
        { 
        bufferedWriter.close();
        status = true;
        }
      catch(Exception e)
        {
        Logger.info("File not opened or already closed " + this);           
        status = false;
        }
      return status;
    }
    
    /**
     * <H1>Read from file</H1>
     * Each line is read and added to data
     * @param file_name String for file name 8.3 format
     * @return whole file as a string
     */
    public String file_read(String file_name) {

        // The name of the file to open.
        String new_file = file_name;
        // This will reference one line at a time
        String line = null;
        String data = null;
        
        try {
            // FileReader reads text files in the default encoding.
            FileReader fileReader = new FileReader(new_file);

            // Always wrap FileReader in BufferedReader.
            BufferedReader bufferedReader = new BufferedReader(fileReader);

            while((line = bufferedReader.readLine()) != null) 
            {
              Logger.info(line);
              data = line;
            }  

            // Always close files.
            bufferedReader.close();  
            return data;
        }
        catch(FileNotFoundException ex) 
        {
        Logger.info("Unable to open file :- " + new_file);
            return data;
        }
        catch(IOException ex) 
        {
          Logger.info("Error reading file :- " + new_file);
            return data;
            // Or we could just do this: 
            // ex.printStackTrace();
        }
    }
    /**
     * <H1>Read File one line</H1>
     * Read file till specific lie is reached then return line as string
     * @param file_name file name 8.3 format
     * @param location the line number in the file that is required
     * @return the whole line as a string
     */
    public String file_read(String file_name, int location) {

        // The name of the file to open.
      int line_location = 0;
        String new_file = file_name;
        // This will reference one line at a time
        String line = null;
        String data = null;
        
        try {
            // FileReader reads text files in the default encoding.
            FileReader fileReader = new FileReader(new_file);

            // Always wrap FileReader in BufferedReader.
            BufferedReader bufferedReader = new BufferedReader(fileReader);
            
            while((line = bufferedReader.readLine()) != null && (line_location != location)) 
            {
              line_location++;
              Logger.info(line);
                data = line;
            }  

            // Always close files.
            bufferedReader.close();  
            return data;
        }
        catch(FileNotFoundException ex) 
        {
        Logger.info("Unable to open file :- " + new_file);
            return data;
        }
        catch(IOException ex) 
        {
            Logger.info("Error reading file :- " + new_file); 
            return data;
        }
    }
  
  
}
