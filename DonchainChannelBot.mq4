//+------------------------------------------------------------------+
//|                                    DonchainChannelBot.mq4        |
//|                                                                  |
//|                                           a.safari1380@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Amir Safari"
#property link      "a.safari1380@gmail.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
datetime ArrayTime[], LastTime;
double Top;
double Buttom;
double OldButtom;
double OldTop;
double price ; 
bool SellTrading ; 
bool BuyTrading ;
int order ; 
bool ClosingPos;
int OnInit()
  {
//---
     Alert("Welcome");
   OldTop = iHigh(Symbol(),Period(),iHighest(Symbol(),Period(),MODE_HIGH,20,0));
   OldButtom = iLow(Symbol(),Period(),iLowest(Symbol(),Period(),MODE_LOW,20,0));
    
 
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  

//Detect price 
price = Bid;
double Movingaverage  = iMA(NULL,0,200,0,MODE_EMA,PRICE_CLOSE,0);
// New Top CheckList

if(Bid > OldTop + 0.00010){
  if(SellTrading){
  //Close Sell
    Alert("Sell Order Closed");
   ClosingPos = OrderClose(order,0.01,Ask,10);
  SellTrading = false;
  }
  if(Bid> Movingaverage && OrdersTotal()==0){
  //Open Buy 
   Alert("Buy Order Initiated On" + Symbol());
  order = OrderSend(NULL,OP_BUY,0.01,Ask,3,OldButtom,NULL,NULL,0,0,NULL);
  BuyTrading = true;
  }
  OldTop = Bid ;
} 

//New Buttom CheckList
if(Bid<OldButtom - 0.00010){
    if(BuyTrading){
    //Close Buy
      Alert("Buy Order Closed");
    ClosingPos = OrderClose(order,0.01,Ask,10);
    BuyTrading = false ;
    }
    if(Bid<Movingaverage && OrdersTotal()==0){
    //Open Sell
    Alert("Sell Order Initiated On" + Symbol());
    order = OrderSend(NULL,OP_SELL,0.01,Bid,3,OldTop,NULL,NULL,0,0,NULL);
    SellTrading = true;
    }
    OldButtom = Bid;
}

       // New Candle St5ick Opening 
     if(NewBar(PERIOD_M30)) {
      OldTop = iHigh(Symbol(),Period(),iHighest(Symbol(),Period(),MODE_HIGH,20,0));
   OldButtom = iLow(Symbol(),Period(),iLowest(Symbol(),Period(),MODE_LOW,20,0));
   }
  }
  bool NewBar(int period) {
    bool firstRun = false, newBar = false;

    ArraySetAsSeries(ArrayTime,true);
    CopyTime(Symbol(),period,0,2,ArrayTime);

    if(LastTime == 0) firstRun = true;
    if(ArrayTime[0] > LastTime) {
        if(firstRun == false) newBar = true;
        LastTime = ArrayTime[0];
    }
    return newBar;   
}
//+------------------------------------------------------------------+