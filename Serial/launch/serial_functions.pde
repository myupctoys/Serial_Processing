/**
 * <H1>Serial Port Function controller</H1>
 * Screen to select optional funcitons to run. Eg timers to send a char out.<br>.
 * Copyright (c) [2022] [Stefan Morley]
 * @author SBM
 * @version 0_2_1
 * MIT Licence attached
*/

import processing.core.PApplet;
import processing.core.PConstants;
import g4p_controls.G4P;
import g4p_controls.GButton;
import g4p_controls.GConstants;
import g4p_controls.GEvent;
import g4p_controls.GLabel;
import g4p_controls.GOption;
import g4p_controls.GTextField;
import g4p_controls.GWinData;
import g4p_controls.GWindow;

public class serial_functions extends PApplet
{
  public GWindow window_functions;
  private PApplet myparent;
  
  String my_path;
  
  int function_window_x = 0;
  int function_window_y = 0;

  private GPanel pnl_function_text;
  
  private GPanel pnl_function_repeat_time;
    
  private GLabel lbl_process1;
  private GLabel lbl_process2;
  private GLabel lbl_process3;
  private GLabel lbl_process4;
  private GPanel pnl_repeat;
  private GPanel pnl_packet_string;
  private GLabel lbl_P1_packet;
  private GLabel lbl_P2_packet;
  private GLabel lbl_P3_packet;
  private GLabel lbl_P4_packet;
  
  private GPanel pnl_save_string;
  
  private GLabel lbl_P1_save;
  private GLabel lbl_P2_save;
  private GLabel lbl_P3_save;
  private GLabel lbl_P4_save;
  
  private GTextField txt_packet_P1;
  private GTextField txt_packet_P2;
  private GTextField txt_packet_P3;
  private GTextField txt_packet_P4;
  
  private GTextField txt_function_P1;
  private GTextField txt_function_P2;
  private GTextField txt_function_P3;
  private GTextField txt_function_P4;
  
  private GTextField txt_timer_P1;
  private GTextField txt_timer_P2;
  private GTextField txt_timer_P3;
  private GTextField txt_timer_P4;
  
  private GTextField txt_save_P1;
  private GTextField txt_save_P2;
  private GTextField txt_save_P3;
  private GTextField txt_save_P4;
  
  private GOption opt_repeat_P1;
  private GOption opt_repeat_P2;
  private GOption opt_repeat_P3;
  private GOption opt_repeat_P4;
  
  private GButton btn_exit_setup; 
  private serial_ports[] specific_process;
  
  public serial_functions(PApplet thisparent, serial_ports[] specific_process, String my_path, int x_pos, int y_pos)
  {
    this.myparent = thisparent;
    this.specific_process = specific_process;
    this.my_path = my_path;
    create_function_gui(x_pos, y_pos);
  }
  
  private void create_function_gui(int x_pos, int y_pos)
  {
    noLoop();
    G4P.messagesEnabled(false);
    G4P.setGlobalColorScheme(GConstants.BLUE_SCHEME);
    G4P.setCursor(PConstants.ARROW);
    if(window_functions == null)
      {
      try
        {
        window_functions = GWindow.getWindow(myparent, "Serial Port Control Functions", 0, 0, 335, 345, JAVA2D);
        window_functions.setLocation(x_pos - (660 + 20 + 20), y_pos);
        }
      catch (Exception e)
        {
        Logger.info("Unable to creater Serial Port Control Functions window");          
        }
      }
    window_functions.noLoop();
    PApplet app = window_functions;  
    window_functions.setActionOnClose(G4P.CLOSE_WINDOW);
    
    window_functions.addDrawHandler(this, "win_functions_draw");
    window_functions.addData(new MyWinData());    
    
    btn_exit_setup = new GButton(app, 226, 310, 100, 33);
    btn_exit_setup.setText("Exit");
    btn_exit_setup.addEventHandler(this, "btn_exit_setup_click");
    
    pnl_function_text = new GPanel(app, 10,10,160,100, "Function to send");
        pnl_function_text.setCollapsible(false); 
        pnl_function_text.setDraggable(false);
        pnl_function_text.setOpaque(true);  
        txt_function_P1 = new GTextField(app, 30, 20, 125, 20);
        txt_function_P1.setText("P1");
        txt_function_P2 = new GTextField(app, 30, 40, 125, 20);
        txt_function_P2.setText("P2");
        txt_function_P3 = new GTextField(app, 30, 60, 125, 20);
        txt_function_P3.setText("P3");
        txt_function_P4 = new GTextField(app, 30, 80, 125, 20);
        txt_function_P4.setText("P4");
        lbl_P1_packet = new GLabel(app, 5, 20, 20,20, "P1");
        lbl_P2_packet = new GLabel(app, 5, 40, 20,20, "P2");
        lbl_P3_packet = new GLabel(app, 5, 60, 20,20, "P3");
        lbl_P4_packet = new GLabel(app, 5, 80, 20,20, "P4");        
        pnl_function_text.addControl(lbl_P1_packet); pnl_function_text.addControl(txt_function_P1);  
        pnl_function_text.addControl(lbl_P2_packet); pnl_function_text.addControl(txt_function_P2);
        pnl_function_text.addControl(lbl_P3_packet); pnl_function_text.addControl(txt_function_P3);
        pnl_function_text.addControl(lbl_P4_packet); pnl_function_text.addControl(txt_function_P4);    
      
    pnl_function_repeat_time = new GPanel(app, 180,10,80,100, "Polling Period");
        pnl_function_repeat_time.setCollapsible(false); 
        pnl_function_repeat_time.setDraggable(false);
        pnl_function_repeat_time.setOpaque(true);          
        txt_timer_P1 = new GTextField(app, 10, 20, 50, 20);
        txt_timer_P1.setText("400");
        txt_timer_P2 = new GTextField(app, 10, 40, 50, 20);
        txt_timer_P2.setText("600");
        txt_timer_P3 = new GTextField(app, 10, 60, 50, 20);
        txt_timer_P3.setText("800");
        txt_timer_P4 = new GTextField(app, 10, 80, 50, 20);
        txt_timer_P4.setText("1000");        
        pnl_function_repeat_time.addControl(txt_timer_P1);
        pnl_function_repeat_time.addControl(txt_timer_P2);
        pnl_function_repeat_time.addControl(txt_timer_P3);
        pnl_function_repeat_time.addControl(txt_timer_P4);       

    pnl_repeat = new GPanel(app,270, 10, 50, 100, "Repeat");
        pnl_repeat.setCollapsible(false); 
        pnl_repeat.setDraggable(false);
        pnl_repeat.setOpaque(true);     
        opt_repeat_P1 = new GOption(app, 5, 20, 20, 20);
        opt_repeat_P2 = new GOption(app, 5, 40, 20, 20);
        opt_repeat_P3 = new GOption(app, 5, 60, 20, 20);
        opt_repeat_P4 = new GOption(app, 5, 80, 20, 20);
        pnl_repeat.addControl(opt_repeat_P1);
        pnl_repeat.addControl(opt_repeat_P2);
        pnl_repeat.addControl(opt_repeat_P3);
        pnl_repeat.addControl(opt_repeat_P4);        
        
    pnl_packet_string = new GPanel(app,10, 120, 315, 100, "Packet String");
        pnl_packet_string.setCollapsible(false); 
        pnl_packet_string.setDraggable(false);
        pnl_packet_string.setOpaque(true); 
        txt_packet_P1 = new GTextField(app,30, 20, 275,20);
        txt_packet_P1.setText("P1");
        txt_packet_P2 = new GTextField(app,30, 40, 275,20);
        txt_packet_P2.setText("P2");
        txt_packet_P3 = new GTextField(app,30, 60, 275,20);
        txt_packet_P3.setText("P3");
        txt_packet_P4 = new GTextField(app,30, 80, 275,20);
        txt_packet_P4.setText("P4");         
        lbl_process1 = new GLabel(app,5,20,50,20, "P1");
        lbl_process2 = new GLabel(app,5,40,50,20, "P2");
        lbl_process3 = new GLabel(app,5,60,50,20, "P3");
        lbl_process4 = new GLabel(app,5,80,50,20, "P4");         
        pnl_packet_string.addControl(lbl_process1); pnl_packet_string.addControl(txt_packet_P1); 
        pnl_packet_string.addControl(lbl_process2); pnl_packet_string.addControl(txt_packet_P2);
        pnl_packet_string.addControl(lbl_process3); pnl_packet_string.addControl(txt_packet_P3);
        pnl_packet_string.addControl(lbl_process4); pnl_packet_string.addControl(txt_packet_P4);        
        
    pnl_save_string = new GPanel(app,10, 230, 205, 100, "File Save");
        pnl_save_string.setCollapsible(false); 
        pnl_save_string.setDraggable(false);
        pnl_save_string.setOpaque(true);     
        lbl_P1_save = new GLabel(app, 5, 20, 20,20, "P1");
        lbl_P2_save = new GLabel(app, 5, 40, 20,20, "P2");
        lbl_P3_save = new GLabel(app, 5, 60, 20,20, "P3");
        lbl_P4_save = new GLabel(app, 5, 80, 20,20, "P4");
        txt_save_P1 = new GTextField(app, 30, 20, 175, 20);
        txt_save_P1.setText("");    
        txt_save_P2 = new GTextField(app, 30, 40, 175, 20);
        txt_save_P2.setText("");
        txt_save_P3 = new GTextField(app, 30, 60, 175, 20);
        txt_save_P3.setText("");
        txt_save_P4 = new GTextField(app, 30, 80, 175, 20);
        txt_save_P4.setText("");      
        pnl_save_string.addControl(lbl_P1_save); pnl_save_string.addControl(txt_save_P1);
        pnl_save_string.addControl(lbl_P2_save); pnl_save_string.addControl(txt_save_P2);
        pnl_save_string.addControl(lbl_P3_save); pnl_save_string.addControl(txt_save_P3);
        pnl_save_string.addControl(lbl_P4_save); pnl_save_string.addControl(txt_save_P4);       
    
    txt_timer_P1.setText(String.valueOf(specific_process[0].get_tx_rate()));   
    txt_timer_P2.setText(String.valueOf(specific_process[1].get_tx_rate()));
    txt_timer_P3.setText(String.valueOf(specific_process[2].get_tx_rate()));
    txt_timer_P4.setText(String.valueOf(specific_process[3].get_tx_rate()));
    
    txt_function_P1.setText(specific_process[0].get_process_name());
    txt_function_P2.setText(specific_process[1].get_process_name());
    txt_function_P3.setText(specific_process[2].get_process_name());
    txt_function_P4.setText(specific_process[3].get_process_name());
    
    txt_packet_P1.setText(specific_process[0].getpacket_string());
    txt_packet_P2.setText(specific_process[1].getpacket_string());
    txt_packet_P3.setText(specific_process[2].getpacket_string());
    txt_packet_P4.setText(specific_process[3].getpacket_string());
    
    txt_save_P1.setText(specific_process[0].getsave_file());
    txt_save_P2.setText(specific_process[1].getsave_file());
    txt_save_P3.setText(specific_process[2].getsave_file());
    txt_save_P4.setText(specific_process[3].getsave_file());    
    if(specific_process[0].getauto_run())
      opt_repeat_P1.setSelected(true);
    if(specific_process[1].getauto_run())
      opt_repeat_P2.setSelected(true);
    if(specific_process[2].getauto_run())
      opt_repeat_P3.setSelected(true);
    if(specific_process[3].getauto_run())
      opt_repeat_P4.setSelected(true);

    window_functions.loop();
    loop();
  }
  
  private int save_settings()
  {
    file_class new_file = new file_class(this.my_path + "\\data\\comms.dat");
    int number_of_lines = 4;
    
      if(opt_repeat_P1.isSelected())
          specific_process[0].setauto_run(true);
      else
        specific_process[0].setauto_run(false);
      
      if(opt_repeat_P2.isSelected())
        specific_process[1].setauto_run(true);
    else
      specific_process[1].setauto_run(false);
      
      if(opt_repeat_P3.isSelected())
        specific_process[2].setauto_run(true);
    else
      specific_process[2].setauto_run(false);
      
      if(opt_repeat_P4.isSelected())
        specific_process[3].setauto_run(true);
    else
      specific_process[3].setauto_run(false);
      
      specific_process[0].set_tx_rate(Integer.valueOf(txt_timer_P1.getText()));
      specific_process[1].set_tx_rate(Integer.valueOf(txt_timer_P2.getText()));
      specific_process[2].set_tx_rate(Integer.valueOf(txt_timer_P3.getText()));
      specific_process[3].set_tx_rate(Integer.valueOf(txt_timer_P4.getText()));
  
      specific_process[0].set_process_name(txt_function_P1.getText());
      specific_process[1].set_process_name(txt_function_P2.getText());
      specific_process[2].set_process_name(txt_function_P3.getText());
      specific_process[3].set_process_name(txt_function_P4.getText());
      
      specific_process[0].setpacket_string(txt_packet_P1.getText());
      specific_process[1].setpacket_string(txt_packet_P2.getText());
      specific_process[2].setpacket_string(txt_packet_P3.getText());
      specific_process[3].setpacket_string(txt_packet_P4.getText());

      specific_process[0].setsave_file(txt_save_P1.getText());
      specific_process[1].setsave_file(txt_save_P2.getText());
      specific_process[2].setsave_file(txt_save_P3.getText());
      specific_process[3].setsave_file(txt_save_P4.getText());
      
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
          Logger.info("Unable to save settings to :- " + new_file);          
        }
       } 
      return flag_file;
  }
  
@SuppressWarnings("unused")  
  public void win_functions_draw(PApplet appc, GWinData data) 
  { //_CODE_:window1:330841:
      appc.background(230);
  } //_CODE_:window1:330841:


  public void btn_exit_setup_click(GButton button, GEvent event) 
  { //_CODE_:btn_exit_setup:443832:
  if(button == btn_exit_setup && event == GEvent.CLICKED)
    {  
    save_settings();
    window_functions.close();
    }
  } //_CODE_:btn_exit_setup:443832:
  
  /**
   * Simple class that extends GWinData and holds the data 
   * that is specific to a particular window.
   * 
   * @author Peter Lager
   */
  class MyWinData extends GWinData 
  {
    int sx, sy, ex, ey;
    boolean done;
    int col;
  }
}
