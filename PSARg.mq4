//+------------------------------------------------------------------+
//|                                                        PSARg.mq4 |
//|                                                          gilbert |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "gilbert"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


#define BEAR 0
#define BULL 1
#define     iBarCURRENT   0                         // Include current bar.

extern double  step      = 0.02;
extern double  maximum   = 0.2;
extern int minTP = 1000;
extern double dLotSize = 0.1; // Position size
extern color clOpenBuy = Blue;
extern color clCloseBuy = Aqua;
extern color clOpenSell = Red;
extern color clCloseSell = Violet;
extern const int SLIPPAGE = 3;
extern int SL = 2000;
extern int CANDLE_FLUCT = 2000;

double lastOrderOP = -1;
bool lock = true;
bool crossToBuy = false;
bool crossToSell = false;

int lastCandleSAR;




//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---



//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  // Comment("");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+


/*void checkOppossing(int orderType){
   if(OrdersTotal() == 1 && orderType == OP_SELL){
      if( iSAR(_Symbol, _Period, step, maximum, 0) < Bid)
         Comment("switch!!!!!!!!!");
   }

}*/

/*bool volume(){
   int vol;
   vol = iVolume(NULL, 0, 0);
   
   return vol > 

}*/

bool isCandleUp(int n){
      
      if(Close[n] - Open[n] > 0)
        return true;
      else if(Close[n] - Open[n] < 0)
             return false;
             
             
           return false;
            
      
}





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void checkTP(int ticket, int orderType,double openPrice, double LL, double HH)
  {


   double highestIncrease = HH - openPrice;
   double currentIncrease = Bid - openPrice;

   double highestDecrease = openPrice - LL;
   double currentDecrease = openPrice - Bid;

   if((OrdersTotal() ==1 && Bid > openPrice+minTP*_Point && orderType == OP_BUY) ||
      (OrdersTotal() ==1 && Bid < openPrice-minTP*_Point && orderType == OP_SELL))
      lock = false;

// if (OrdersTotal() ==1 && Bid < openPrice-2000*_Point && orderType == OP_SELL) selllock = false;

//  if(Bid < openPrice-2000*_Point && orderType == OP_SELL) locked = false;

   if(orderType == OP_BUY)
     {
      if(lock == false)
        {
         if(currentIncrease < highestIncrease - highestIncrease*0.3)
           {
            // Comment("should TP");

            for(int i=0; i<OrdersTotal(); i++)
              {
               if(OrderSelect(i, SELECT_BY_POS))
                 {
                  OrderClose(OrderTicket(),OrderLots(),Bid, SLIPPAGE,clCloseBuy);
                  lock = true;
                 }

              }
           }

        }
     }

   else
      if(orderType == OP_SELL)
        {
         if(lock == false)
           {

            if(currentDecrease < highestDecrease - highestDecrease*0.3)
              {


               for(int i=0; i<OrdersTotal(); i++)
                 {
                  if(OrderSelect(i, SELECT_BY_POS))
                    {
                     //      Comment("should TPSELLLL");
                     OrderClose(OrderTicket(),OrderLots(),Ask, SLIPPAGE, clCloseSell);
                     lock = true;
                    }

                 }
              }

           }


        }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SARPos(int n)
  {
   double SARValue [5];

   for(int i =0; i < n; i++)
      SARValue[i] = iSAR(_Symbol, _Period, step, maximum, i);
      
      
   if(SARValue[n-1] < Close[n-1]){
 //  Comment("IM LESS THAN CLOSE");
      for(int i=0;i < n-1; i++){
         if(SARValue[i] < Close[i])
            return false;
      }
      
      return true;
   
   }
   
    if(SARValue[n-1] > Close[n-1]){
      for(int i=0;i < n-1; i++){
         if(SARValue[i] > Close[i])
            return false;
      }
      
      return true;
   
   }
   return false;
   
   
  /* if((Close[2] > SARValue[2] && Close[1] < SARValue[1] && Close[0] < SARValue[0])
      || (Close[2] < SARValue[2] && Close[1] > SARValue[1] && Close[0] > SARValue[0]))
      return true;

   return false;*/
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool isGreen(){

   if(Close[0] > Open[0])
   return true;
   
   return false;
   
}
int detectTrend(double SARValue)
  {

   /*MqlRates priceArray[];
   ArraySetAsSeries(priceArray, true);
   int data = CopyRates(_Symbol, _Period, 0, 3, priceArray);

   double SARArray[];
   int mySARValue =  iSAR(_Symbol, _Period, step, maximum, 0);
   ArraySetAsSeries(SARArray, true);

   CopyBuffer(mySARValue, 0, 0, 3, SARArray);*/
   int counter = 0;

   if(SARValue < Bid)
     {
     
    /* if(SARPos(2) == true && OrdersTotal() == 0){
         if((Close[0] - Close[1] > 2000 * _Point && isCandleUp(1) == true)
            || (Close[0] - Open[1] > 2000 * _Point && isCandleUp(1) == false ))
            return BULL;
     }*/
     
    if(SARPos(3) == true && OrdersTotal() == 0){
    
     for(int i=0;i < 2; i++){
            if(isCandleUp(i) == true)
               counter++;         
         }
         
           if(counter != 2)
               return -1;
               
            else if(Close[0] - Open[1] >= CANDLE_FLUCT * _Point && isGreen()) //close 0 150 pt       if(Close[1] - Open[1] >= 300 * _Point 
            return BULL;
     }
     
      if(SARPos(4) == true && OrdersTotal() == 0){
      
    //  if(Open[0] - Open[2] > 250) return BULL;
 //     Comment("IM AT 33333333");
         for(int i=0;i < 3; i++){
            if(isCandleUp(i) == true )
               counter++;         
         }
         if(counter != 3)
               return -1;
         else{
            if(Close[1] - Close[2] >= CANDLE_FLUCT * _Point)
               return BULL;
               
             else
                  return -1;
         }
         

    //   return BULL;
      
      }
      
      else if (SARPos(5) == true && OrdersTotal() == 0){
          for(int i=0;i < 4; i++){
            if(isCandleUp(i) == true)
               counter++;         
         }
         
           if(counter != 4)
               return -1;
               
            else
                  return BULL;
         
         
      }
     }
   else
      if(SARValue > Ask)
        {
         ///////////////////////////////////////
         
         
         
          if(SARPos(3) == true && OrdersTotal() == 0){
    
     for(int i=0;i < 2; i++){
            if(isCandleUp(i) == false)
               counter++;         
         }
         
           if(counter != 2)
               return -1;
               
            else
                 
         if(Open[1] - Close[0] >= CANDLE_FLUCT * _Point && isGreen() == false)
            return BEAR;
     }
     
      if(SARPos(4) == true && OrdersTotal() == 0){
      
    //  if(Open[0] - Open[2] > 250) return BULL;
  //    Comment("IM AT 33333333");
         for(int i=0;i < 3; i++){
            if(isCandleUp(i) == false)
               counter++;         
         }
         if(counter != 3)
               return -1;
         else{
            if(Close[1] - Close[2] <= -CANDLE_FLUCT * _Point)
               return BEAR;
               
             else
                  return -1;
         }
         

    //   return BULL;
      
      }
      
      else if (SARPos(5) == true && OrdersTotal() == 0){
          for(int i=0;i < 4; i++){
            if(isCandleUp(i) == false)
               counter++;         
         }
         
           if(counter != 4)
               return -1;
               
            else
                  return BEAR;
         
         
      }
         
         
         
         ////////////////////////////////////////
        
        }

   return 0;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double HH()
  {

   if(OrdersTotal() == 1)
     {

      datetime    OOT         = OrderOpenTime();          // Assumes OrderSelect() done already
      int         iOOT        = iBarShift(_Symbol,_Period, OOT);    // Bar of the open.
      int         nSince  = iOOT - iBarCURRENT + 1;       // No. bars since open.
      int         iHi         = iHighest(_Symbol,_Period, MODE_HIGH, nSince, iBarCURRENT);
      double      HH          = High[iHi];                // Highest high.

      return HH;

     }
   return 0;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LL()
  {

   if(OrdersTotal() == 1)
     {
      datetime    OOT         = OrderOpenTime();          // Assumes OrderSelect() done already
      int         iOOT        = iBarShift(_Symbol,_Period, OOT);    // Bar of the open.
      int         nSince  = iOOT - iBarCURRENT + 1;       // No. bars since open.
      int         iLi         = iLowest(_Symbol, _Period, MODE_LOW, nSince, iBarCURRENT);
      double      LL          = Low[iLi];                 // Lowest low.
      return LL;

     }

   return 0;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool crossBuy(double slowMovingAverage,double lastSlowMovingAverage,double fastMovingAverage,double lastFastMovingAverage)
  {
   if(lastFastMovingAverage < lastSlowMovingAverage
      && fastMovingAverage > slowMovingAverage)
     {

      return true;


     }

   return false;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool crossSell(double slowMovingAverage,double lastSlowMovingAverage,double fastMovingAverage,double lastFastMovingAverage)
  {
   if(lastFastMovingAverage > lastSlowMovingAverage
      && fastMovingAverage < slowMovingAverage)
     {

      return true;


     }

   return false;

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
  



   int ticket;


/////////////////////////////


   double SARValue = iSAR(_Symbol, _Period, step, maximum, 0);
// double EMA = iMA(_Symbol, _Period, 20, 0, MODE_EMA, PRICE_CLOSE, 0);
   double MACD = iMACD(NULL, 0, 12,26,9, PRICE_CLOSE, MODE_MAIN, 0);

   double slowMovingAverage = iMA(NULL,0, 40, 0, MODE_SMA, PRICE_CLOSE, 0);
   double lastSlowMovingAverage = iMA(NULL,0, 40, 0, MODE_SMA, PRICE_CLOSE, 20);
   double fastMovingAverage = iMA(NULL,0, 20, 0, MODE_SMA, PRICE_CLOSE, 0);
   double lastFastMovingAverage = iMA(NULL,0, 20, 0, MODE_SMA, PRICE_CLOSE, 20);




   /* if(lastFastMovingAverage < lastSlowMovingAverage
       && fastMovingAverage > slowMovingAverage)
      {
       Comment("buy");
      }

    if(lastFastMovingAverage > lastSlowMovingAverage
       && fastMovingAverage < slowMovingAverage)
      {
       Comment("sell");
      }*/






   int signal = detectTrend(SARValue);

   if(
      signal == BULL
      && OrdersTotal() == 0
      //&& isSecondSAR()
//&& Bid > EMA
// && MACD > 0
//   && crossBuy(slowMovingAverage, lastSlowMovingAverage, fastMovingAverage, lastFastMovingAverage) == true

   )
     {

      //ticket = OrderSend(_Symbol, OP_BUY, dLotSize, Ask, 3,Ask-1000*_Point  , Ask+2000*_Point, NULL, 0,0, Green);
      ticket = OrderSend(_Symbol, OP_BUY, dLotSize, Ask, SLIPPAGE, Ask-SL*_Point,0, NULL, 0,0, clOpenBuy);

     }

   if(
      signal == BEAR
      && OrdersTotal() == 0
      && SARPos(4)
//&& Bid < EMA
// && MACD < 0
// &&  crossSell(slowMovingAverage, lastSlowMovingAverage, fastMovingAverage, lastFastMovingAverage) == true
   )
     {

      // ticket = OrderSend(_Symbol, OP_SELL,dLotSize, Bid, 3, Bid+1000*_Point, Bid-2000*_Point, NULL, 0,0, Red);
      ticket = OrderSend(_Symbol, OP_SELL,dLotSize, Bid, SLIPPAGE, Bid+SL*_Point,0, NULL, 0,0, clOpenSell);

     }

   if(ticket>0)
      OrderSelect(ticket,SELECT_BY_TICKET);




   checkTP(ticket, OrderType(), OrderOpenPrice(), LL(), HH());
//  checkOppossing(OrderType());

   Comment("the signal is ", signal, "\n",
           "order open price :", OrderOpenPrice(), "\n",
           "HH : ", HH(), "\n",
           "LL : ", LL());


  }
//+------------------------------------------------------------------+
