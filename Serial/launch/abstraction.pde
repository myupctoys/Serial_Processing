public int which_port_generated_serial_event(Serial p)
{
int port = 0;
    if(p == new_serial.specific_process[0].getMyPort())
      port = 0;
    if(p == new_serial.specific_process[1].getMyPort())
      port = 1;
    if(p == new_serial.specific_process[2].getMyPort())
      port = 2;
    if(p == new_serial.specific_process[3].getMyPort())
      port = 3;
return port;      
}

public String return_rx_serial_data(Serial p)
{
  new_serial.specific_process[which_port_generated_serial_event(p)].serialEvent(p);
  String inString = new_serial.specific_process[which_port_generated_serial_event(p)].strarray_rx[new_serial.specific_process[which_port_generated_serial_event(p)].current_rx_pointer];
  Logger.debug("Current rx_pointer :- " + new_serial.specific_process[which_port_generated_serial_event(p)].current_rx_pointer);
  new_serial.specific_process[which_port_generated_serial_event(p)].current_rx_pointer ++;
  new_serial.specific_process[which_port_generated_serial_event(p)].current_rx_pointer %= 4;
return inString;    
}

public String return_serial_port_name(Serial p)
{
  return new_serial.specific_process[which_port_generated_serial_event(p)].getMyPortname();
}

public boolean operate_on_new_serial_event(Serial p)
{
  boolean is_valid = false;
  try
  {
  new_serial.specific_process[which_port_generated_serial_event(p)].serialEvent(p);
  is_valid = true;
  }
  catch (Exception e)
  {
  Logger.info("Not a valid Serial Event :- " + this);    
  is_valid = false;
  }
return is_valid;
}

  public file_class open_for_write_to_file(PApplet p, int process)
  {
    String my_path = p.sketchPath();
    file_class new_file = new file_class(my_path + "\\data\\" + new_serial.specific_process[process].getsave_file() + " " + generate_dtg_file() + ".csv");
    Logger.info(new_file.get_new_file());
    return new_file;
  }

static final javax.swing.JFrame getJFrame(final PSurface surface) 
{
  return (javax.swing.JFrame) ( (processing.awt.PSurfaceAWT.SmoothCanvas) surface.getNative()).getFrame();
}
