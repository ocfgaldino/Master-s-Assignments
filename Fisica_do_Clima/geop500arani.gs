
*************Reiniciando o grads e abrindo o arquivo de dados***********
'reinit'
'sdfopen C:\OPENGR~1\Contents\geouvarani.nc'

*************definindo caracteristicas e mapas do grads***********
'set display color white'
'c'
'set grads off'
'set grid off'
'set mpdset brmap_hires'
'set map 1 1 8'

*************Fazendo o loop dos horarios e dias***********

n=1
while(n<=16)


*************definindo tonalidadade e as cores***********
'set map 1 1 8'
*Tons de azul
'set rgb 41 225 255 255'
'set rgb 42 180 240 250'
'set rgb 43 150 210 250'
'set rgb 44 120 185 250'
'set rgb 45  80 165 245'
'set rgb 46  60 150 245'
'set rgb 47  40 130 240'
'set rgb 48  30 110 235'
'set rgb 49  20 100 210'

*Tons de amarelo
'set rgb 21 255 250 170'
'set rgb 22 255 232 120'
'set rgb 23 255 192  60'
'set rgb 24 255 160   0'
'set rgb 25 255  96   0'
'set rgb 26 255  50   0'
'set rgb 27 225  20   0'
'set rgb 28 192   0   0'
'set rgb 29 165   0   0'

'set grid off'
'set grads off'
'set t 'n
'q time'
data=subwrd(result,3)
ano=substr(data,9,4)
mes=substr(data,6,3)
dia = substr(data,4,2)
hora = substr(data,1,2)


*************campo de geopotencial***********
*************definindo nivel e dividindo a variavel para escala final***********
'set lev 500'
'define h=z/10'

'set gxout shaded'
*'cores.gs'
'set clevs 5200 5250 5300 5350 5400 5450 5500 5550 5600 5650 5700'
'set ccols 49 48 47 45 43 41 21 22 23 24 25 27'
'd h'
'cbarn.gs'

*********campo de vento********

'set gxout stream'
'set ccolor 1' 
'set strmden 1'
'd u;v;mag(u,v)'
*'d u;v'
'set line 1 1 8'
'draw shp C:\Users\MichaelBezerra\Desktop\Clima\Trabalho\shapes\BaciadeCampos\Campos-polygon.shp'



*********imprimindo figuras ********
'draw title Linha de Corrente (ms-1) e Altura Geop (mgp) em 500 hPa\'data
'printim  C:\Users\MichaelBezerra\Desktop\Clima\Trabalho\resultados2\geop500_'data'.png'
'c'

*************campo de geopotencial***********
*************definindo nivel e dividindo a variavel para escala final***********
'set lev 850'
'define h=z/10'

'set gxout shaded'
*'cores.gs'
'set clevs 1100 1150 1200 1250 1300 1350 1400 1450 1500 1550 1600'
'set ccols 49 48 47 45 43 41 21 22 23 24 25 27'
'd h'
'cbarn.gs'


*********campo de vento********

'set gxout stream'
'set ccolor 1' 
'set strmden 1'
'd u;v;mag(u,v)'
*'d u;v'
'set line 1 1 8'
'draw shp C:\Users\MichaelBezerra\Desktop\Clima\Trabalho\shapes\BaciadeCampos\Campos-polygon.shp'


'draw title Linha de Corrente (ms-1) e Altura Geop (mgp) em 850 hPa\'data
'printim  C:\Users\MichaelBezerra\Desktop\Clima\Trabalho\resultados2\geop850_'data'.png'
'c'

*************campo de geopotencial***********
*************definindo nivel e dividindo a variavel para escala final***********
'set lev 200'
'define h=z/10'

'set gxout shaded'
*'cores.gs'
'set clevs 11100 11200 11300 11400 11500 11600 11700 11800 11900 12000 12100 12200'
'set ccols 49 48 47 45 43 41 21 22 23 24 25 27 28'
'd h'
'cbarn.gs'


*********campo de vento********

'set gxout stream'
'set ccolor 1' 
'set strmden 1'
'd u;v;mag(u,v)'
*'d u;v'
'set line 1 1 8'
'draw shp C:\Users\MichaelBezerra\Desktop\Clima\Trabalho\shapes\BaciadeCampos\Campos-polygon.shp'


'draw title Linha de Corrente (ms-1) e Altura Geop (mgp) em 200 hPa\'data
'printim  C:\Users\MichaelBezerra\Desktop\Clima\Trabalho\resultados2\geop200_'data'.png'
'c'

n=n+1
endwhile
