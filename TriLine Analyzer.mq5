#property copyright "Sedsist"
#property link      "sedsist@gmail.com"
#property version   "1.01"
#property strict
#property indicator_chart_window

#property indicator_buffers 3
#property indicator_plots   3

//--- plot Linea Superior
#property indicator_label1  "Linea Superior"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

//--- plot Linea Inferior
#property indicator_label2  "Linea Inferior"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

//--- plot Linea Media
#property indicator_label3  "Linea Media"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1

double BufferSuperior[];
double BufferInferior[];
double BufferMedia[];

int OnInit()
{
   SetIndexBuffer(0, BufferSuperior, INDICATOR_DATA);
   SetIndexBuffer(1, BufferInferior, INDICATOR_DATA);
   SetIndexBuffer(2, BufferMedia, INDICATOR_DATA);
   
   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   int limite = MathMin(rates_total, 200);
   if(limite < 100) return(0);  // Esperamos a tener al menos 100 velas
   
   int inicio = rates_total - limite;
   
   // Encontrar el punto más alto y más bajo
   double maximo = high[inicio];
   double minimo = low[inicio];
   for(int i = inicio + 1; i < rates_total; i++)
   {
      if(high[i] > maximo) maximo = high[i];
      if(low[i] < minimo) minimo = low[i];
   }
   
   // Calcular la línea media
   double media = 0;
   int conteo[100] = {0};
   for(int i = 0; i < 100; i++)
   {
      double nivel = minimo + (maximo - minimo) * i / 99;
      for(int j = inicio; j < rates_total; j++)
      {
         if(low[j] <= nivel && high[j] >= nivel)
            conteo[i]++;
      }
      if(conteo[i] > conteo[(int)media])
         media = i;
   }
   media = minimo + (maximo - minimo) * media / 99;
   
   // Dibujar las líneas
   for(int i = inicio; i < rates_total; i++)
   {
      BufferSuperior[i] = maximo;
      BufferInferior[i] = minimo;
      BufferMedia[i] = media;
   }
   
   return(rates_total);
}