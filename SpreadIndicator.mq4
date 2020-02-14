//+------------------------------------------------------------------+
//|                                              SpreadIndikator.mq4 |
//|                               Copyright © 2010 MeinMetatrader.de |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010 MeinMetatrader.de"
#property link      ""

#property indicator_chart_window
//#property indicator_buffers 0

extern color LabelColor = Red;

#define OBJ_NAME "SpreadIndikatorObj"

int init()
{
   ShowSpread();
}

int start()
{
   ShowSpread();
}

int deinit()
{
   ObjectDelete(OBJ_NAME);
}

void ShowSpread()
{
   static double spread;
   
   spread = MarketInfo(Symbol(), MODE_SPREAD);
   
   DrawSpreadOnChart(spread);
}

void DrawSpreadOnChart(double spread)
{
   string s = "Spread: "+DoubleToStr(spread, 0)+" points";
   
   if(ObjectFind(OBJ_NAME) < 0)
   {
      ObjectCreate(OBJ_NAME, OBJ_LABEL, 0, 0, 0);
      ObjectSet(OBJ_NAME, OBJPROP_CORNER, 0);
      ObjectSet(OBJ_NAME, OBJPROP_YDISTANCE, 12);
      ObjectSet(OBJ_NAME, OBJPROP_XDISTANCE, 3);
      ObjectSetText(OBJ_NAME, s, 10, "FixedSys", LabelColor);
   }
   
   ObjectSetText(OBJ_NAME, s);
   
   WindowRedraw();
}