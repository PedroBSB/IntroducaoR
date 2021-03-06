###### Aula 5: Gera��o de gr�ficos e Amostragem Complexa. ######
setwd("C:\\Users\\Dados\\POF 2008")
##Exemplo 1: Invoca a fun��o LeBasesPosicaoFixa.R
source("LeBasesPosicaoFixa.R")

### Cria um novo arquivo somene com as informa��es necess�rias
# Seleciona tudo: 
fselpr<-function(x) x
#Seleciona somente UF 53: fselpr <- function(x) x[substring(x,3,4)==53]
rcsel.pfix(file.inp="T_MORADOR_S.txt", file.out="MORADOR.txt",
           first=c(3,5,8,9,11,12,60,112),
           last=c(4,7,8,10,11,13,62,127),
           fselpr)
###L� os dados do arquivo de interesse
dados<-read.table("MORADOR.txt")
###Deleta o arquivo MORADOR.txt
file.remove("MORADOR.txt")
#Coloca os nomes das vari�veis
colnames(dados)<-c("COD_UF","NUM_SEQ","NUM_DV","COD_DOMC","NUM_UC","NUM_INFORMANTE",
                   "IDADE_ANOS","RENDA_BRUTA_MONETARIA")
#Coloca os labels nas vari�veis
library(Hmisc)
label(dados$COD_UF)<-'C�DIGO DA UF'
label(dados$NUM_SEQ)<-'N�MERO SEQUENCIAL'
label(dados$NUM_DV)<-'DV DO SEQUENCIAL'
label(dados$COD_DOMC)<-'N�MERO DO DOMIC�LIO'
label(dados$NUM_UC)<-'N�MERO DA UC'
label(dados$NUM_INFORMANTE)<-'N�MERO DO INFORMANTE'
label(dados$IDADE_ANOS)<-'IDADE CALCULADA EM ANOS'
label(dados$RENDA_BRUTA_MONETARIA)<-'RENDA MONET�RIA MENSAL DA UC'
describe(dados)

##Exemplo 2: Invoca o pacote dplyr e faz o filtro
library(dplyr)
tudo53<-filter(tudo,COD_UF==53)

##Exemplo 3: Renomeia a vari�vel
tudo53<-rename(tudo53,INGRESSO=VAL_DESPESA)
head(tudo53)

##Exemplo 4: Elimina as linhas repetidas
tudo.simples<-distinct(select(tudo53, COD_UF,NUM_SEQ,
                              NUM_DV,COD_DOMC,NUM_UC,
                              NUM_INF,IDADE_ANOS))

##Exemplo 5: Cria as novas vari�veis
tudo53<-mutate(tudo53,
               Indice = (INGRESSO-min(INGRESSO, na.rm = T))/
                 (max(INGRESSO, na.rm = T)-min(INGRESSO, na.rm = T)),
               Z = (INGRESSO-mean(INGRESSO, na.rm = T))/sd(INGRESSO, na.rm = T)
)


##Exemplo 6: Acha algumas medidas de interesse
estat<-summarise(tudo53,
                 Ingresso.m = mean(INGRESSO, na.rm = TRUE),
                 Ingresso.sd = sd(INGRESSO, na.rm = TRUE),
                 Idade = mean(IDADE_ANOS, na.rm = TRUE),
                 Idade.sd = sd(IDADE_ANOS, na.rm = TRUE)
                 )
estat

#Exemplo 7:Usando a fun��o group_by(.)
by_tudo <- group_by(tudo, COD_UF)
#Faz as estat�sticas por UF
estat.UF <- summarise(by_tudo,
                      count = n(),
                      Ingresso.m = mean(VAL_DESPESA, na.rm = TRUE),
                      Ingresso.sd = sd(VAL_DESPESA, na.rm = TRUE),
                      Idade = mean(IDADE_ANOS, na.rm = TRUE),
                      Idade.sd = sd(IDADE_ANOS, na.rm = TRUE))
#Calcula as estat�sticas por grupo
tudo.estat<-mutate(by_tudo,
                   Indice = (VAL_DESPESA-min(VAL_DESPESA, na.rm = T))/
                     (max(VAL_DESPESA, na.rm = T)-min(VAL_DESPESA, na.rm = T)),
                   Z = (VAL_DESPESA-mean(VAL_DESPESA, na.rm = T))/
                     sd(VAL_DESPESA, na.rm = T)
)


#Exemplo 8: Importando os dados do Excel.
setwd("C:\\User\\Dados")
library(XLConnect)
wb <- loadWorkbook("USEletric.xls")
df <- readWorksheet(wb, sheet = "Data", header = TRUE)












