//+------------------------------------------------------------------+
//|                                                         xADR.mq4 |
//|                                                        by xecret |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "xecret"
#property indicator_chart_window

extern bool ExcludeSundayData=true;
extern int ATR1_Prd=5,ATR2_Prd=25;
extern double RoomLimitRatio=0.2;
extern color TradeableColor=Lime;
extern color UntradeableColor=Red;
extern color OtherColor=Lime;
extern int DisplayPosition=2;
//extern string   d1_                     =" : Corner : 0=Top Left";
//extern string   d2_                     =" : : 1=Top Right";
//extern string   d3_                     =" : : 2=Bottom Left";
//extern string   d4_                     =" : : 3=Bottom Right";

double point;
int    LastBars0=0;
int    DisplayCorner;
int x,y;

int init(){
  point=Point;
  if( Digits==3 || Digits==5 ) point=point*10;
  
  if (DisplayPosition==0) {DisplayCorner=0;x=0;y=0;} else {DisplayCorner=2;x=-215;y=1;}
  ObjectCreate("xADR1", OBJ_LABEL, 0, 0, 0);
  ObjectSet("xADR1", OBJPROP_CORNER, DisplayCorner);
  ObjectSet("xADR1", OBJPROP_XDISTANCE, 250+x);
  ObjectSet("xADR1", OBJPROP_YDISTANCE, y);
  
  ObjectCreate("xADR2", OBJ_LABEL, 0, 0, 0);
  ObjectSet("xADR2", OBJPROP_CORNER, DisplayCorner);
  ObjectSet("xADR2", OBJPROP_XDISTANCE, 470+x);
  ObjectSet("xADR2", OBJPROP_YDISTANCE, y);
  
  ObjectCreate("xADR5", OBJ_LABEL, 0, 0, 0);
  ObjectSet("xADR5", OBJPROP_CORNER, DisplayCorner);
  ObjectSet("xADR5", OBJPROP_XDISTANCE, 400+x);
  ObjectSet("xADR5", OBJPROP_YDISTANCE, y);
  return(0);
}

int deinit(){
  ObjectDelete("xADR1");ObjectDelete("xADR2");ObjectDelete("xADR3");ObjectDelete("xADR4");ObjectDelete("xADR5");
  return(0);
}

int start(){
  string text; color Color;
  int Bars0=Bars;
  if(Bars0>LastBars0){
    //ATR Part==========================================================
    int atr1,atr2;
    atr1=MathRound(iATR(NULL,0,ATR1_Prd,1)/point);
    atr2=MathRound(iATR(NULL,0,ATR2_Prd,1)/point);
    text="ATR" + ATR1_Prd + "=" + atr1 + "  ATR" + ATR2_Prd + "=" + atr2;
    if (atr1<atr2) Color=UntradeableColor; else Color=TradeableColor; 
    ObjectSetText("xADR1",text,10, "Arial Bold", Color);
  
    //ADR Part==========================================================
    int n=1;  
    int adr1,adr5,adr10,adr20,adr;
    double s=0.0;    
    for(int i=1;i<=20;i++){
      while(ExcludeSundayData && TimeDayOfWeek(iTime(NULL,PERIOD_D1,n))==0) n++;
      s=s + ( iHigh(NULL,PERIOD_D1,n) - iLow(NULL,PERIOD_D1,n) )/point;
      if(i==1) adr1=MathRound(s);
      if(i==5) adr5=MathRound(s/5);
      if(i==10) adr10=MathRound(s/10);
      if(i==20) adr20=MathRound(s/20);
      n++;  
    }  
    adr  = MathRound((adr1+adr5+adr10+adr20)/4.0);
    text="Y="+adr1+"  ADR="+adr+"  5d="+adr5+"  10d="+adr10+"  20d="+adr20;
    ObjectSetText("xADR2",text,10, "Arial Bold", OtherColor);
    LastBars0=Bars0;
  }
  
  //Today's Range and Room============================================  
  int t,RmUp,RmDn,RmLmt;
  double low0  =  iLow(NULL,PERIOD_D1,0);
  double high0 =  iHigh(NULL,PERIOD_D1,0);
  t = MathRound((high0 - low0)/point);  
  RmUp =  MathRound(adr - (Bid - low0)/point);
  RmDn =  MathRound(adr - (high0 - Bid)/point);
  RmLmt =  MathRound(adr*RoomLimitRatio);
  
  text="RmUp:"+RmUp;
  if (RmUp<RmLmt) Color=UntradeableColor; else Color=TradeableColor;
  ObjectSetText("xADR3",text,10, "Arial Bold", Color);
  
  text="RmDn:"+RmDn;
  if (RmDn<RmLmt) Color=UntradeableColor; else Color=TradeableColor;
  ObjectSetText("xADR4",text,10, "Arial Bold", Color);
  
  text="T="+t;
  ObjectSetText("xADR5",text,10, "Arial Bold", OtherColor);  
  
  return(0);
}
//+------------------------------------------------------------------+