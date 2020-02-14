//+------------------------------------------------------------------+
//| ADX Crossing.mq4 
//| Amir
//+------------------------------------------------------------------+
#property  copyright "Author - Amir"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
//---- input parameters
extern int  ADXbarsPeriod       = 14;
extern bool UseADX_level        = true;
extern int  ADX_level_Threshold  = 20;

extern int CountBars=350;
extern bool alert =true;
extern bool sound =true;
extern string SoundFile="wait.waw";
//---- buffers
double val1[];
double val2[];
double b4plusdi,nowplusdi,b4minusdi,nowminusdi,b4adxmain,nowadxmain;
bool SoundBuy=False;
bool SoundSell=False;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,108);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,108);
   SetIndexBuffer(0,val1);
   SetIndexBuffer(1,val2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| AltrTrend_Signal_v2_2                                            |
//+------------------------------------------------------------------+
int start()
  {
   if (CountBars>=Bars) CountBars=Bars;
   SetIndexDrawBegin(0,Bars-CountBars);
   SetIndexDrawBegin(1,Bars-CountBars);
   int i,shift,limit,CountedBars=IndicatorCounted();
   if (CountedBars < 1)
     {
      for(i=0; i<=CountBars; i++) {val1[i]=0.0; val2[i]=0.0;}
     }

   if(CountedBars > 0) CountedBars--;
//----   
   limit=Bars - CountedBars;
//----
   for(shift=limit; shift>=0; shift--)
     {
      b4plusdi=iADX(NULL,0,ADXbarsPeriod,PRICE_CLOSE,MODE_PLUSDI,shift+1);
      nowplusdi=iADX(NULL,0,ADXbarsPeriod,PRICE_CLOSE,MODE_PLUSDI,shift);
      b4minusdi=iADX(NULL,0,ADXbarsPeriod,PRICE_CLOSE,MODE_MINUSDI,shift+1);
      nowminusdi=iADX(NULL,0,ADXbarsPeriod,PRICE_CLOSE,MODE_MINUSDI,shift);
      b4adxmain = iADX(NULL,0,ADXbarsPeriod,PRICE_CLOSE,MODE_MAIN,shift+1);
      nowadxmain = iADX(NULL,0,ADXbarsPeriod,PRICE_CLOSE,MODE_MAIN,shift);
 
  
   if   (UseADX_level) 
     {
      if (b4plusdi<b4minusdi && nowplusdi>nowminusdi  &&  nowadxmain >= ADX_level_Threshold)
         
         val1[shift]=Low[shift]-5*Point;
         
       if (b4adxmain < ADX_level_Threshold && nowadxmain > ADX_level_Threshold && nowplusdi>nowminusdi)
         
         val1[shift]=Low[shift]-5*Point;
            
         
      if (b4plusdi>b4minusdi && nowplusdi<nowminusdi  &&  nowadxmain >= ADX_level_Threshold)
       val2[shift]=High[shift]+5*Point;
      if (b4adxmain < ADX_level_Threshold && nowadxmain > ADX_level_Threshold && nowplusdi<nowminusdi)
          val2[shift]=High[shift]+5*Point;
         
         
         

 
     } 
   
     else 
      {
      if (b4plusdi<b4minusdi && nowplusdi>nowminusdi)
         {
         val1[shift]=Low[shift]-5*Point;
         }
      if (b4plusdi>b4minusdi && nowplusdi<nowminusdi)
         {
         val2[shift]=High[shift]+5*Point;
         }
       } 
     }
   if (val1[0]!=EMPTY_VALUE && val1[0]!=0 && SoundBuy)
     {
      SoundBuy=False;
      if (alert) Alert(Symbol(), " M", Period(), " ADX Cross UP");
      if (sound) PlaySound (SoundFile);
      
     }
   if (!SoundBuy && (val1[0]==EMPTY_VALUE || val1[0]==0)) SoundBuy=True;
   if (val2[0]!=EMPTY_VALUE && val2[0]!=0 && SoundSell)
     {
      SoundSell=False;
      if (sound) PlaySound (SoundFile);
      if (alert) Alert(Symbol(), " M", Period(), " ADX Cross Dn");
     }
   if (!SoundSell && (val2[0]==EMPTY_VALUE || val2[0]==0)) SoundSell=True;
   return(0);
  }
//+------------------------------------------------------------------+