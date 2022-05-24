/**
 * <H1>Serial Port Parameters</H1>
 * Screen to select assorted serial port parameters and allow opening
 * and controlling of ports.<br>
 * Does also allow the serial_functions screen to be opened which are
 * extended serial port parameters used to control what the serial port
 * does.
 * Copyright (c) [2022] [Stefan Morley]
 * @author SBM
 * @version 0_2_1
 * MIT Licence attached
*/
import java.io.IOException;
import g4p_controls.G4P;
import g4p_controls.GAlign;
import g4p_controls.GButton;
import g4p_controls.GConstants;

import g4p_controls.GEvent;
import g4p_controls.GOption;
import g4p_controls.GPanel;
import g4p_controls.GToggleGroup;
import g4p_controls.GWinData;
import g4p_controls.GWindow;
import processing.core.PApplet;
import processing.core.PConstants;
import processing.serial.Serial;

public class serial_gui extends PApplet
{
  public GWindow window_serial = null; 
  public PApplet myparent;
  
  private GButton btn_open_port;
  private GButton btn_close_port;
  private GButton btn_open_port_all;
  private GButton btn_close_port_all;
  private GButton btn_exit_setup; 

  private GButton btn_reload;
  private GButton btn_load_defaults;
  
  private GButton btn_function;
  
  private GPanel pnl_port; 
  private GToggleGroup tgl_port; 
  private GOption[] port;
  
  private GPanel pnl_baud; 
  private GToggleGroup tgl_baud; 
  private GOption baud_600;   
  private GOption baud_1200; 
  private GOption baud_2400; 
  private GOption baud_4800; 
  private GOption baud_9600; 
  private GOption baud_14400; 
  private GOption baud_19200; 
  private GOption baud_28800; 
  private GOption baud_38400; 
  private GOption baud_57600; 
  private GOption baud_115200; 
  private GOption baud_256000;
  private GOption baud_512000;
  private GOption baud_1000000;
  private GPanel pnl_parity; 
  private GToggleGroup tgl_parity; 
  private GOption parity_even; 
  private GOption parity_odd; 
  private GOption parity_none; 
  private GPanel pnl_bits; 
  private GToggleGroup tgl_bits; 
  private GOption bits_7; 
  private GOption bits_8; 
  private GPanel pnl_stop; 
  private GToggleGroup tgl_stop; 
  private GOption stop_10; 
  private GOption stop_15; 
  private GOption stop_20;   
  private GPanel pnl_process;
  private GToggleGroup tgl_process;
  private GOption proc_p1;
  private GOption proc_p2;
  private GOption proc_p3;
  private GOption proc_p4;
  
  private String my_path;
  
  private int current_process;
  private int x_loc, y_loc;
  
  public serial_ports[] specific_process = new serial_ports[4];
  
  private file_class new_file; // = new file_class(sketchPath("data/comms.dat"));
  private int number_of_lines = 0;
  
  serial_functions specific_serial_function;
  
  /**
   * Constructor for serial_gui
   * @param thisparent parent Applet reference
   */
  public serial_gui(PApplet thisparent, int x_loc, int y_loc)
  {
    this.myparent = thisparent;
    this.my_path = myparent.sketchPath();
    this.x_loc = x_loc;
    this.y_loc = y_loc;
    new_file = new file_class(this.my_path + "\\data\\comms.dat");
    for(int i = 0; i < 4; i++)
    {
      specific_process[i] = new serial_ports(thisparent);
    }
    create_gui();
    load_settings();
    update_screen_process();
  }

  private void set_number_bits(serial_ports ports_open)
  {
    if(ports_open.getBits() == 7)
      bits_7.setSelected(true);
    else if(ports_open.getBits() == 8)
      bits_8.setSelected(true);
  }

  private void set_parity(serial_ports ports_open)
  {
    if(ports_open.getParity().equals("E"))
      parity_even.setSelected(true);
    else if(ports_open.getParity().equals("O"))
      parity_odd.setSelected(true);
    else if(ports_open.getParity().equals("N"))
      parity_none.setSelected(true);
  }

  private void set_stop(serial_ports ports_open)
  {
    if(ports_open.getStop() == 1.0)
      stop_10.setSelected(true);
    else if(ports_open.getStop() == 1.5)
      stop_15.setSelected(true);
    else if(ports_open.getStop() == 2.0)
      stop_20.setSelected(true);
  }

  private void set_baud(serial_ports ports_open)
  {
    if(ports_open.getBaud_rate() == 600)
      baud_600.setSelected(true);
    else if(ports_open.getBaud_rate() == 1200)
      baud_1200.setSelected(true);
    else if(ports_open.getBaud_rate() == 2400)
      baud_2400.setSelected(true);
    else if(ports_open.getBaud_rate() == 4800)
      baud_4800.setSelected(true);
    else if(ports_open.getBaud_rate() == 9600)
      baud_9600.setSelected(true);
    else if(ports_open.getBaud_rate() == 14400)
      baud_14400.setSelected(true);
    else if(ports_open.getBaud_rate() == 28800)
      baud_28800.setSelected(true);
    else if(ports_open.getBaud_rate() == 38400)
      baud_38400.setSelected(true);
    else if(ports_open.getBaud_rate() == 57600)
      baud_57600.setSelected(true);
    else if(ports_open.getBaud_rate() == 115200)
      baud_115200.setSelected(true);
    else if(ports_open.getBaud_rate() == 256000)
      baud_256000.setSelected(true);
    else if(ports_open.getBaud_rate() == 512000)
      baud_512000.setSelected(true);
    else if(ports_open.getBaud_rate() == 1000000)
      baud_1000000.setSelected(true);  
  }
  
  private void set_port(serial_ports ports_open)
  {
    String[] inByte = null;
@SuppressWarnings("unused")    
    int port_associated_with_process = -1;
    inByte = Serial.list();
    int number_of_ports = inByte.length;
    
    if(proc_p1.isSelected())
      port_associated_with_process = 0;
    else if(proc_p2.isSelected())
      port_associated_with_process = 1;
    else if(proc_p3.isSelected())
      port_associated_with_process = 2;
    else if(proc_p4.isSelected())
      port_associated_with_process = 3;
    
    for(int i=0; i < number_of_ports; i++)
    {      
        if(ports_open.getMyPortname().equals(port[i].getText()))
        {
          port[i].setSelected(true);
          break;
        }
    }
  }
  
  private void set_gui_options_based_on(serial_ports ports_open)
  {
    set_number_bits(ports_open);
    set_parity(ports_open);      // Read the current process and update parameters on screen
    set_baud(ports_open);
    set_stop(ports_open);
    set_port(ports_open);
  }
  
  public serial_ports get_specific_process(int process)
  {
    return specific_process[process];
  }
  
  private void update_screen_process()
  {
    if(proc_p1.isSelected())
    {
      set_gui_options_based_on(specific_process[0]);
    }
    if(proc_p2.isSelected())
    {
      set_gui_options_based_on(specific_process[1]);  
    }
    if(proc_p3.isSelected())
    {
      set_gui_options_based_on(specific_process[2]);  
    }
    if(proc_p4.isSelected())
    {
      set_gui_options_based_on(specific_process[3]);  
    }
    
    
  }
  
  private boolean load_settings()
  {
      String load_settings = "";
      boolean load_flag = false;
      number_of_lines = 0;
      try 
      {
      number_of_lines = new_file.countLines(this.my_path + "\\data\\comms.dat");
      } 
      catch (IOException e) 
      {
      Logger.info(this.my_path + "\\data\\comms.dat" + " is not avalable");
      e.printStackTrace();
      }
      for(int i = 1; i < number_of_lines + 1; i++)
      {
      load_settings = new_file.file_read(this.my_path + "\\data\\comms.dat", i);

      if(load_settings != null)
        {
        String[] token = load_settings.split(",");
                  if(token.length >= 8)
                  {
                  specific_process[(i-1)].setMyPortname(token[0]);
                  specific_process[(i-1)].setBaud_rate(Integer.valueOf(token[1]));
                  specific_process[(i-1)].setBits(Integer.valueOf(token[2]));
                  specific_process[(i-1)].setStop(Float.valueOf(token[3]));
                  specific_process[(i-1)].setTx_rate(Integer.valueOf(token[4]));  
                  specific_process[(i-1)].setTimer_function(token[5]);
                  specific_process[(i-1)].setParity(token[6]);    
                  specific_process[(i-1)].setBuffer_char(Byte.valueOf(token[7]));
                  specific_process[(i-1)].setProcess(Integer.valueOf(token[8]));
                  specific_process[(i-1)].setauto_run(Boolean.valueOf(token[9]));
                  specific_process[(i-1)].set_process_name(token[10]);
                  specific_process[(i-1)].setpacket_string(token[11]);
                  specific_process[(i-1)].setsave_file(token[12]);
                  load_flag = true;
                  }
        }
      }
      return load_flag;
  }
  
  private int save_settings()
  {
      String save_settings = "";
      int flag_file = 0;
      new_file.file_write(save_settings);
      for(int i = 0; i < number_of_lines; i++)
        {
        try
        {
        save_settings = specific_process[i].getMyPortname() + ',' + specific_process[i].getBaud_rate() + ',' + specific_process[i].getBits() + ',' +  specific_process[i].getStop() + 
          ',' + specific_process[i].getTx_rate() + ',' + specific_process[i].getTimer_function() + ',' + specific_process[i].getParity().charAt(0) + ',' 
          + specific_process[i].getBuffer_char() + ',' + i + ',' + specific_process[i].getauto_run() + ',' + specific_process[i].get_process_name() + 
          ',' + specific_process[i].getpacket_string() + ',' + specific_process[i].getsave_file() + "\r";
        
        new_file.file_append(save_settings);
        flag_file++;
        }
        catch (Exception e)
        {
        Logger.info(this.my_path + "\\data\\comms.dat" + " is not avalable");          
        }
       } 
      return flag_file;
  }
  
  private String gather_parity_bits()
  {
  String parity_bits = "0";
  if(parity_even.isSelected())
    parity_bits = "E";
  if(parity_odd.isSelected())
    parity_bits = "O";
  if(parity_none.isSelected())
    parity_bits = "N";
  return parity_bits;
  }
  
  private String gather_stop_bits()
  {
  String stop_bits = "0";
  if(stop_10.isSelected())
    stop_bits = "1.0";
  if(stop_15.isSelected())
    stop_bits = "1.5";
  if(stop_20.isSelected())
    stop_bits = "2.0";
  return stop_bits;
  }
  
  private String gather_number_of_bits()
  {
  String number_bits = "0";
  if(bits_7.isSelected())
    number_bits = "7";
  if(bits_8.isSelected())
    number_bits = "8";
  return number_bits;
  }
  
  private String gather_baud()
  {
  String baud_rate = "0";
  if(baud_600.isSelected())
    baud_rate = "600";
  if(baud_1200.isSelected())
    baud_rate = "1200";
  if(baud_4800.isSelected())
    baud_rate = "4800";
  if(baud_9600.isSelected())
    baud_rate = "9600";
  if(baud_14400.isSelected())
    baud_rate = "14400";
  if(baud_28800.isSelected())
    baud_rate = "28800";
  if(baud_38400.isSelected())
    baud_rate = "38400";
  if(baud_57600.isSelected())
    baud_rate = "57600";
  if(baud_115200.isSelected())
    baud_rate = "115200";
  if(baud_256000.isSelected())
    baud_rate = "256000";
  if(baud_512000.isSelected())
    baud_rate = "512000";
  if(baud_1000000.isSelected())
    baud_rate = "1000000";
  return baud_rate;
  }
    
  private String gather_comm_port()
  {
    String[] inByte = null;
    inByte = Serial.list();
    int number_of_ports = inByte.length;
    String comm_port = "0";
       
    for(int i=0; i < number_of_ports; i++)
    {      
        if(port[i].isSelected())
        {
          comm_port = port[i].getText();
          break;
        }
    }
    return comm_port;
  }
  
  private void gather_serial_paramters()
  {    
    specific_process[current_process].setMyPortname(gather_comm_port()); 
    specific_process[current_process].setBaud_rate(Integer.parseInt(gather_baud()));
    specific_process[current_process].setBits(Integer.parseInt(gather_number_of_bits()));
    specific_process[current_process].setStop(Float.parseFloat(gather_stop_bits()));
    specific_process[current_process].setParity(gather_parity_bits());
    //ports_open[current_process].getTx_rate();
    //ports_open[current_process].getTimer_function();
    //ports_open[current_process].getBuffer_char();
  }
  
  @SuppressWarnings("unused")
  void populate_ports(PApplet app)
  {
    int i;
    int ypitch = 20;
    String[] inByte = null;
    inByte = Serial.list();
    port = new GOption[inByte.length];
    String osname = System.getProperty("os.name", "").toLowerCase();
    if(osname.startsWith("windows"))
      {
      }
    else if (osname.startsWith("linux"))
      {
      }
    else
      {
      }
    
    printArray(inByte);    

    for(i=0; i<inByte.length; i++)
    {  
      if(i > 13)
        break;
      port[i] = new GOption(this.window_serial, 5, 20 + (i * ypitch), 90, 20, inByte[i]);  
      port[i].addEventHandler(this, "optioneventhandler");
      port[i].setAlpha(255);
      port[i].tagNo = i;
    }
    // Add event Handlers after populating ports to prevent concurrent exceptions
    noLoop();
    //port[i-1].setSelected(true);
    for(i=0; i<inByte.length; i++)
      {
      pnl_port.addControl(port[i]);
      tgl_port.addControl(port[i]);
      port[i].addEventHandler(this, "comm_ports_clicked");
      }
    loop();  
    gather_serial_paramters();
    }
    
  public void create_gui()
  {
      noLoop();    
      G4P.messagesEnabled(false);
      G4P.setGlobalColorScheme(GConstants.BLUE_SCHEME);
      G4P.setCursor(PConstants.ARROW);
      if(window_serial == null)
        {
        window_serial = GWindow.getWindow(myparent, "Serial Port Parameters", 0, 0, 325, 380, JAVA2D);
        window_serial.setLocation(this.x_loc - (325 + 20), this.y_loc);
        }
      window_serial.noLoop();
      PApplet app = window_serial;
 
      window_serial.setActionOnClose(G4P.CLOSE_WINDOW);
      window_serial.addDrawHandler(this, "win_serial_draw");
      window_serial.addData(new MyWinData1());
      
      btn_open_port = new GButton(app, 8, 347, 65, 30);
      btn_open_port.setText("Open");
      btn_open_port.addEventHandler(this, "btn_open_port_click");
      
      btn_close_port = new GButton(app, 77, 347, 65, 30);
      btn_close_port.setText("Close");
      btn_close_port.addEventHandler(this, "btn_close_port_click");
      
      btn_open_port_all = new GButton(app, 146, 347, 65, 30);
      btn_open_port_all.setText("Open All");
      btn_open_port_all.addEventHandler(this, "btn_open_port_all_click");    
      
      btn_close_port_all = new GButton(app, 146, 312, 65, 30);
      btn_close_port_all.setText("Close All");
      btn_close_port_all.addEventHandler(this, "btn_close_port_all_click");
      
      btn_reload =new GButton(app, 77, 312, 65, 30);
      btn_reload.setText("Reload");
      btn_reload.addEventHandler(this, "btn_reload_click");
      
      btn_exit_setup = new GButton(app, 216, 347, 100, 30);
      btn_exit_setup.setText("Exit");
      btn_exit_setup.addEventHandler(this, "btn_exit_setup_click");
      
      btn_function = new GButton(app, 216, 312, 100, 30);
      btn_function.setText("Functions");
      btn_function.addEventHandler(this, "btn_function_click");
      
      btn_load_defaults = new GButton(app, 8, 312, 65, 30);
      btn_load_defaults.setText("Defaults");
      btn_load_defaults.addEventHandler(this, "btn_load_defaults_click");
      
      pnl_port = new GPanel(app, 8, 8, 100, 298, "Comm Port");
      pnl_port.setCollapsible(false);
      pnl_port.setDraggable(false);
      pnl_port.setOpaque(true);
      tgl_port = new GToggleGroup();
      
      pnl_baud = new GPanel(app, 112, 8, 100, 298, "Baud Rate");
      pnl_baud.setCollapsible(false); 
      pnl_baud.setDraggable(false);
      pnl_baud.setOpaque(true);
      tgl_baud = new GToggleGroup();
      baud_600 = new GOption(app, 4, 20, 88, 20);
      baud_600.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_600.setText("600");
      baud_600.setOpaque(false);
      baud_600.addEventHandler(this, "baud_600_clicked");    
      baud_1200 = new GOption(app, 4, 40, 88, 20);
      baud_1200.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_1200.setText("1200");
      baud_1200.setOpaque(false);
      baud_1200.addEventHandler(this, "baud_1200_clicked");
      baud_2400 = new GOption(app, 4, 60, 88, 20);
      baud_2400.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_2400.setText("2400");
      baud_2400.setOpaque(false);
      baud_2400.addEventHandler(this, "baud_2400_clicked");
      baud_4800 = new GOption(app, 4, 80, 88, 20);
      baud_4800.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_4800.setText("4800");
      baud_4800.setOpaque(false);
      baud_4800.addEventHandler(this, "baud_4800_clicked");
      baud_9600 = new GOption(app, 4, 100, 88, 20);
      baud_9600.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_9600.setText("9600");
      baud_9600.setOpaque(false);
      baud_9600.addEventHandler(this, "baud_9600_clicked");
      baud_14400 = new GOption(app, 4, 120, 88, 20);
      baud_14400.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_14400.setText("14400");
      baud_14400.setOpaque(false);
      baud_14400.addEventHandler(this, "baud_14400_clicked");
      baud_19200 = new GOption(app, 4, 140, 88, 20);
      baud_19200.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_19200.setText("19200");
      baud_19200.setOpaque(false);
      baud_19200.addEventHandler(this, "baud_19200_clicked");
      baud_28800 = new GOption(app, 4, 160, 88, 20);
      baud_28800.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_28800.setText("28800");
      baud_28800.setOpaque(false);
      baud_28800.addEventHandler(this, "baud_28800_clicked");
      baud_38400 = new GOption(app, 4, 180, 88, 20);
      baud_38400.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_38400.setText("38400");
      baud_38400.setOpaque(false);
      baud_38400.addEventHandler(this, "baud_38400_clicked");
      baud_57600 = new GOption(app, 4, 200, 88, 20);
      baud_57600.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_57600.setText("57600");
      baud_57600.setOpaque(false);
      baud_57600.addEventHandler(this, "baud_57600_clicked");
      baud_115200 = new GOption(app, 4, 220, 88, 20);
      baud_115200.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_115200.setText("115200");
      baud_115200.setOpaque(false);
      baud_115200.addEventHandler(this, "baud_115200_clicked");
      baud_256000 = new GOption(app, 4, 240, 88, 20);
      baud_256000.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_256000.setText("256000");
      baud_256000.setOpaque(false);
      baud_256000.addEventHandler(this, "baud_256000_clicked");
      baud_512000 = new GOption(app, 4, 260, 88, 20);
      baud_512000.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_512000.setText("512000");
      baud_512000.setOpaque(false);
      baud_512000.addEventHandler(this, "baud_512000_clicked");  
      baud_1000000 = new GOption(app, 4, 280, 88, 20);
      baud_1000000.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      baud_1000000.setText("1000000");
      baud_1000000.setOpaque(false);
      baud_1000000.addEventHandler(this, "baud_1000000_clicked");  
      tgl_baud.addControl(baud_600);
      pnl_baud.addControl(baud_600);
      tgl_baud.addControl(baud_1200);
      pnl_baud.addControl(baud_1200);
      tgl_baud.addControl(baud_2400);
      pnl_baud.addControl(baud_2400);
      tgl_baud.addControl(baud_4800);
      pnl_baud.addControl(baud_4800);
      tgl_baud.addControl(baud_9600);
      baud_9600.setSelected(true);
      pnl_baud.addControl(baud_9600);
      tgl_baud.addControl(baud_14400);
      pnl_baud.addControl(baud_14400);
      tgl_baud.addControl(baud_19200);
      pnl_baud.addControl(baud_19200);
      tgl_baud.addControl(baud_28800);
      pnl_baud.addControl(baud_28800);
      tgl_baud.addControl(baud_38400);
      pnl_baud.addControl(baud_38400);
      tgl_baud.addControl(baud_57600);
      pnl_baud.addControl(baud_57600);
      tgl_baud.addControl(baud_115200);
      pnl_baud.addControl(baud_115200);
      tgl_baud.addControl(baud_256000);
      pnl_baud.addControl(baud_256000);
      tgl_baud.addControl(baud_512000);
      pnl_baud.addControl(baud_512000);   
      tgl_baud.addControl(baud_1000000);
      pnl_baud.addControl(baud_1000000);      
      
      pnl_parity = new GPanel(app, 216, 72, 100, 80, "Parity");
      pnl_parity.setCollapsible(false);
      pnl_parity.setDraggable(false);
      pnl_parity.setOpaque(true);
      tgl_parity = new GToggleGroup();
      parity_even = new GOption(app, 4, 20, 90, 20);
      parity_even.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      parity_even.setText("Even");
      parity_even.setOpaque(false);
      parity_even.addEventHandler(this, "parity_even_clicked");
      parity_odd = new GOption(app, 4, 40, 90, 20);
      parity_odd.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      parity_odd.setText("Odd");
      parity_odd.setOpaque(false);
      parity_odd.addEventHandler(this, "parity_odd_clicked");
      parity_none = new GOption(app, 4, 60, 90, 20);
      parity_none.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      parity_none.setText("None");
      parity_none.setOpaque(false);
      parity_none.addEventHandler(this, "parity_none_clicked");
      tgl_parity.addControl(parity_even);
      pnl_parity.addControl(parity_even);
      tgl_parity.addControl(parity_odd);
      pnl_parity.addControl(parity_odd);
      tgl_parity.addControl(parity_none);
      parity_none.setSelected(true);
      pnl_parity.addControl(parity_none);
      
      pnl_bits = new GPanel(app, 216, 8, 100, 60, "Number of bits");
      pnl_bits.setCollapsible(false);
      pnl_bits.setDraggable(false);
      pnl_bits.setOpaque(true);
//      pnl_bits.addEventHandler(this, "pnl_bits_Click");
      tgl_bits = new GToggleGroup();
      bits_7 = new GOption(app, 4, 20, 88, 20);
      bits_7.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      bits_7.setText("7");
      bits_7.setOpaque(false);
      bits_7.addEventHandler(this, "bits_7_clicked");
      bits_8 = new GOption(app, 4, 40, 88, 20);
      bits_8.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      bits_8.setText("8");
      bits_8.setOpaque(false);
      bits_8.addEventHandler(this, "bits_8_clicked");
      tgl_bits.addControl(bits_7);
      pnl_bits.addControl(bits_7);
      tgl_bits.addControl(bits_8);
      bits_8.setSelected(true);
      pnl_bits.addControl(bits_8);
      
      pnl_stop = new GPanel(app, 216, 156, 100, 80, "Stop Bits");
      pnl_stop.setCollapsible(false);
      pnl_stop.setDraggable(false);
      pnl_stop.setOpaque(true);
//      pnl_stop.addEventHandler(this, "panel1_Click");
      tgl_stop = new GToggleGroup();
      stop_10 = new GOption(app, 4, 20, 88, 20);
      stop_10.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      stop_10.setText("1.0");
      stop_10.setOpaque(false);
      stop_10.addEventHandler(this, "stop_10_clicked");
      stop_15 = new GOption(app, 4, 40, 88, 20);
      stop_15.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      stop_15.setText("1.5");
      stop_15.setOpaque(false);
      stop_15.addEventHandler(this, "stop_15_clicked");
      stop_20 = new GOption(app, 4, 60, 88, 20);
      stop_20.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      stop_20.setText("2.0");
      stop_20.setOpaque(false);
      stop_20.addEventHandler(this, "stop_20_clicked");
      tgl_stop.addControl(stop_10);
      stop_10.setSelected(true);
      pnl_stop.addControl(stop_10);
      tgl_stop.addControl(stop_15);
      pnl_stop.addControl(stop_15);
      tgl_stop.addControl(stop_20);
      pnl_stop.addControl(stop_20);
 
      pnl_process = new GPanel(app, 216, 240, 100, 66, "Process");
      pnl_process.setCollapsible(false);
      pnl_process.setDraggable(false);
      pnl_process.setOpaque(true);    
      proc_p1 = new GOption(app, 4, 18, 35, 20);
      proc_p1.addEventHandler(this, "proc_p1_clicked");
      proc_p1.setText("P1");
      pnl_process.addControl(proc_p1);
      proc_p2 = new GOption(app, 43, 18, 35, 20);
      proc_p2.addEventHandler(this, "proc_p2_clicked");
      proc_p2.setText("P2");
      pnl_process.addControl(proc_p2);
      proc_p3 = new GOption(app, 4, 42, 35, 20);
      proc_p3.addEventHandler(this, "proc_p3_clicked");
      proc_p3.setText("P3");
      pnl_process.addControl(proc_p3);
      proc_p4 = new GOption(app, 43, 42, 35, 20);
      proc_p4.addEventHandler(this, "proc_p4_clicked");
      proc_p4.setText("P4");
      pnl_process.addControl(proc_p4);
      tgl_process = new GToggleGroup();
      tgl_process.addControl(proc_p1);
      tgl_process.addControl(proc_p2);
      tgl_process.addControl(proc_p3);
      tgl_process.addControl(proc_p4);
      proc_p1.setSelected(true);
      
      populate_ports(app);
      window_serial.loop();
      loop();
  }
  
  //////
  //  NEED TO ADD comm port option handle
  //////
  
  public void proc_p1_clicked(GOption option, GEvent event) 
  { /* code */ 
  if(option == proc_p1 && event == GEvent.SELECTED )
    {     
    current_process = 0;
    update_screen_process();
    }
  }
  
  public void proc_p2_clicked(GOption option, GEvent event) 
  { /* code */  
  if(option == proc_p2 && event == GEvent.SELECTED )
    {   
    current_process = 1;
    update_screen_process();
    }
  }
  public void proc_p3_clicked(GOption option, GEvent event) 
  { /* code */ 
  if(option == proc_p3 && event == GEvent.SELECTED )
    {   
    current_process = 2;
    update_screen_process();
    }
  }
  public void proc_p4_clicked(GOption option, GEvent event) 
  { /* code */   
  if(option == proc_p4 && event == GEvent.SELECTED )
    {   
    current_process = 3;
    update_screen_process();
    }
  }
@SuppressWarnings("unused")  
  public void optioneventhandler(GOption source, GEvent event) 
  { //_CODE_:option1:548628:
    } //_CODE_:option1:548628:
  
  public void btn_exit_setup_click(GButton source, GEvent event) 
  { //_CODE_:btn_exit_setup:443832:
  if(source == btn_exit_setup && event == GEvent.CLICKED)
    {    
    save_settings();
    if(specific_serial_function != null)
        {
        specific_serial_function.window_functions.close();
        }    
    window_serial.close();
    }
  } //_CODE_:btn_exit_setup:443832:

  public void btn_reload_click(GButton source, GEvent event)
  {
  if(source == btn_reload && event == GEvent.CLICKED)
    {      
    load_settings();
    update_screen_process();
    }
  }
  
  public void btn_open_port_click(GButton source, GEvent event) 
  { //_CODE_:btn_open_port:462845:  
  if(source == btn_open_port && event == GEvent.CLICKED)
    {    
    specific_process[current_process].open_port(specific_process[current_process].getauto_run());
    specific_process[current_process].port_x_of_x = current_process + 1;
    set_port_colour(current_process, GConstants.GREEN_SCHEME);
    }
  } //_CODE_:btn_open_port:462845:
  
  private void set_port_colour(int current, int colour)
  {
    String[] inByte = null;
    inByte = Serial.list();
    int number_of_ports = inByte.length;
    
    for(int i = 0; i < number_of_ports; i++)
      {
    if(port[i].getText().equals(specific_process[current].getMyPortname()))
      // && specific_process[current].getPort_is_open()
        { 
        port[i].setLocalColorScheme(colour);
        pnl_port.setLocalColorScheme(colour);
        pnl_baud.setLocalColorScheme(colour);
        pnl_parity.setLocalColorScheme(colour);
        pnl_bits.setLocalColorScheme(colour);
        pnl_stop.setLocalColorScheme(colour);
        switch (current)
        {
        case 0:
          {
          proc_p1.setLocalColorScheme(colour);
          break;
          }
        case 1:
          {
          proc_p2.setLocalColorScheme(colour);
          break;
          }
        case 2:
          {
          proc_p3.setLocalColorScheme(colour);
          break;
          }
        case 3:
          {
          proc_p4.setLocalColorScheme(colour);
          break;
          }
        }
        }
      }
  }
  
  public void btn_close_port_click(GButton source, GEvent event)
  {
  if(source == btn_close_port && event == GEvent.CLICKED)
    {      
    specific_process[current_process].port_destructor();
    specific_process[current_process].port_x_of_x = 0;
    set_port_colour(current_process, GConstants.BLUE_SCHEME);
    }
  }
  
  public void btn_load_defaults_click(GButton source, GEvent event)
  {
  if(source == btn_load_defaults && event == GEvent.CLICKED)
    {      
    load_defaults_btn();
    }
  }
  
  private void load_defaults_btn()
  {
    for(int i = 0; i<4; i++)
    {
      specific_process[i].load_default_parameters();
    }
  }
  
  public void btn_close_port_all_click(GButton source, GEvent event) 
  { //_CODE_:btn_open_port_all:462845:
  if(source == btn_close_port_all && event == GEvent.CLICKED)
    {    
      specific_process[0].port_destructor();
      set_port_colour(0, GConstants.BLUE_SCHEME);
      specific_process[0].port_x_of_x = 0;
      specific_process[1].port_destructor();
      set_port_colour(1, GConstants.BLUE_SCHEME);
      specific_process[1].port_x_of_x = 0;
      specific_process[2].port_destructor();
      set_port_colour(2, GConstants.BLUE_SCHEME);
      specific_process[2].port_x_of_x = 0;
      specific_process[3].port_destructor();
      set_port_colour(3, GConstants.BLUE_SCHEME);
      specific_process[3].port_x_of_x = 0;
    }
  }
  
  public void btn_open_port_all_click(GButton source, GEvent event) 
  { //_CODE_:btn_open_port_all:462845:
  if(source == btn_open_port_all && event == GEvent.CLICKED)
    {    
      if(specific_process[0].open_port(specific_process[0].getauto_run()))
        set_port_colour(0, GConstants.GREEN_SCHEME);
      else
        set_port_colour(0, GConstants.RED_SCHEME);
      specific_process[0].port_x_of_x = 1;
      if(specific_process[1].open_port(specific_process[1].getauto_run()))
        set_port_colour(1, GConstants.GREEN_SCHEME);
      else
        set_port_colour(0, GConstants.RED_SCHEME);
      specific_process[1].port_x_of_x = 2;
      if(specific_process[2].open_port(specific_process[2].getauto_run()))
        set_port_colour(2, GConstants.GREEN_SCHEME);
        else
          set_port_colour(0, GConstants.RED_SCHEME);
      set_port_colour(2, GConstants.GREEN_SCHEME);
      specific_process[2].port_x_of_x = 3;
      if(specific_process[3].open_port(specific_process[3].getauto_run()))
        set_port_colour(3, GConstants.GREEN_SCHEME);
      else
        set_port_colour(0, GConstants.RED_SCHEME);
      specific_process[3].port_x_of_x = 4;
    }
  }
  
  public void btn_function_click(GButton button, GEvent event)
  { //_CODE_:btn_open:596998:
  if(button == btn_function && event == GEvent.CLICKED)
    {
    specific_serial_function = new serial_functions(this, specific_process, this.my_path, x_loc, y_loc);
    }
  }
  
@SuppressWarnings("unused")  
  public void comm_ports_clicked(GOption source, GEvent event) 
  { //_CODE_:stop_20:417978:
      gather_serial_paramters();  
  } //_CODE_:stop_20:417978:  

@SuppressWarnings("unused")
  public void pnl_baud_Click(GPanel source, GEvent event) 
  { //_CODE_:pnl_baud:912412:
  } //_CODE_:pnl_baud:912412:
  
  public void baud_600_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_600:382366:
  if(source == baud_600 && event == GEvent.SELECTED )
    {  
    gather_serial_paramters();
    }
  } //_CODE_:baud_600:382366:
  
  public void baud_1200_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_1200:419428:
  if(source == baud_1200 && event == GEvent.SELECTED )
    {  
    gather_serial_paramters();
    }
  } //_CODE_:baud_1200:419428:

  public void baud_2400_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_2400:248094:
  if(source == baud_2400 && event == GEvent.SELECTED )
    {  
    gather_serial_paramters();
    }
  } //_CODE_:baud_2400:248094:

  public void baud_4800_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_4800:961131:
  if(source == baud_4800 && event == GEvent.SELECTED )
    {  
    gather_serial_paramters();
    }
  } //_CODE_:baud_4800:961131:

  public void baud_9600_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_9600:641623:
  if(source == baud_9600 && event == GEvent.SELECTED )
    {  
    gather_serial_paramters();
    }
  } //_CODE_:baud_9600:641623:

  public void baud_14400_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_14400:427668:
  if(source == baud_14400 && event == GEvent.SELECTED )
    {  
    gather_serial_paramters();
    }
  } //_CODE_:baud_14400:427668:

  public void baud_19200_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_19200:450073:
  if(source == baud_19200 && event == GEvent.SELECTED )
    {  
    gather_serial_paramters();
    }
  } //_CODE_:baud_19200:450073:

  public void baud_28800_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_28800:457823:
  if(source == baud_28800 && event == GEvent.SELECTED )
    {  
    gather_serial_paramters();
    }
  } //_CODE_:baud_28800:457823:

  public void baud_38400_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_38400:961711:
  if(source == baud_38400 && event == GEvent.SELECTED )
    {  
    gather_serial_paramters();
    }    
  } //_CODE_:baud_38400:961711:

  public void baud_57600_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_57600:263897:
  if(source == baud_57600 && event == GEvent.SELECTED )
    {  
    gather_serial_paramters();
    }
  } //_CODE_:baud_57600:263897:

  public void baud_115200_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_115200:269606:
  if(source == baud_115200 && event == GEvent.SELECTED )
    {
    gather_serial_paramters();
    }
  } //_CODE_:baud_115200:269606:

  public void baud_256000_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_256000:988532:
  if(source == baud_256000 && event == GEvent.SELECTED )
    {  
    gather_serial_paramters();
    }
  } //_CODE_:baud_256000:988532:

  public void baud_512000_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_512000:988532:
  if(source == baud_512000 && event == GEvent.SELECTED )
    {  
      gather_serial_paramters();
    }
  } //_CODE_:baud_512000:988532:  
  
  public void baud_1000000_clicked(GOption source, GEvent event) 
  { //_CODE_:baud_1000000:988532:
  if(source == baud_1000000 && event == GEvent.SELECTED )
    {  
      gather_serial_paramters();
    }
  } //_CODE_:baud_1000000:988532:  

@SuppressWarnings("unused")  
  public void pnl_parity_Click(GPanel source, GEvent event) 
  { //_CODE_:pnl_parity:612437:
  } //_CODE_:pnl_parity:612437:

  public void parity_even_clicked(GOption source, GEvent event) 
  { //_CODE_:parity_even:850689:
  if(source == parity_even && event == GEvent.SELECTED )
    {     
    gather_serial_paramters();
    }
  } //_CODE_:parity_even:850689:

  public void parity_odd_clicked(GOption source, GEvent event) 
  { //_CODE_:parity_odd:735328:
  if(source == parity_odd && event == GEvent.SELECTED )
    {     
    gather_serial_paramters();
    }
  } //_CODE_:parity_odd:735328:

  public void parity_none_clicked(GOption source, GEvent event) 
  { //_CODE_:parity_none:809368:
  if(source == parity_none && event == GEvent.SELECTED )
    {       
    gather_serial_paramters();
    }
  } //_CODE_:parity_none:809368:

@SuppressWarnings("unused")
  public void pnl_bits_Click(GPanel source, GEvent event) 
  { //_CODE_:pnl_bits:401118:
  } //_CODE_:pnl_bits:401118:

  public void bits_7_clicked(GOption source, GEvent event) 
  { //_CODE_:bits_7:610938:
  if(source == bits_7 && event == GEvent.SELECTED )
    {     
    gather_serial_paramters();
    }
  } //_CODE_:bits_7:610938:

  public void bits_8_clicked(GOption source, GEvent event) 
  { //_CODE_:bits_8:314043:
  if(source == bits_8 && event == GEvent.SELECTED )
    {   
    gather_serial_paramters();
    }
  } //_CODE_:bits_8:314043:

@SuppressWarnings("unused")
  public void panel1_Click(GPanel source, GEvent event) 
  { //_CODE_:pnl_stop:684786:
  } //_CODE_:pnl_stop:684786:

  public void stop_10_clicked(GOption source, GEvent event) 
  { //_CODE_:stop_10:842252:
  if(source == stop_10 && event == GEvent.SELECTED )
    {     
    gather_serial_paramters();
    }
  } //_CODE_:stop_10:842252:

  public void stop_15_clicked(GOption source, GEvent event) 
  { //_CODE_:stop_15:870889:
  if(source == stop_15 && event == GEvent.SELECTED )
    {     
    gather_serial_paramters();
    }
  } //_CODE_:stop_15:870889:

  public void stop_20_clicked(GOption source, GEvent event) 
  { //_CODE_:stop_20:417978:
  if(source == stop_20 && event == GEvent.SELECTED )
    {     
    gather_serial_paramters();
    }
  } //_CODE_:stop_20:417978:  

@SuppressWarnings("unused")  
  synchronized public void win_serial_draw(PApplet appc, GWinData data) 
  { //_CODE_:window1:330841:
      appc.background(230);
  } //_CODE_:window1:330841:
  /**
   * Simple class that extends GWinData and holds the data 
   * that is specific to a particular window.
   * 
   * @author Peter Lager
   */
  public class MyWinData1 extends GWinData 
  {
    int sx, sy, ex, ey;
    boolean done;
    int col;
  }
}
