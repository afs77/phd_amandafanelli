#Criado por Amanda Fanelli em 03/2021
#Conteudo disponivel no instagram phd_amandafanelli

#Para criar um heatmap ou mapa de calor no R, precisamos dos dados numéricos na forma de uma matriz

# Com as linhas abaixo, vamos gerar uma matriz e chamá-la de test, com os dados de exemplo (não se preocupe se nao entender essa parte)
test <- matrix(rnorm(300), 10, 4)
colnames(test) <- c("folha","raiz","caule","flor")
rownames(test) <- paste("Gene", LETTERS[seq(from = 1, to = 10)], sep = " ")

#Agora, para criar um heatmap basta utilizar a função heatmap(), usando a matriz test:
heatmap(test)


#Este é o heatmap mais simples que podemos criar. Agora, podemos ajustar vários parametros dentro da função heatmap (Argumentos)
#Veja os parâmetros que podem ser modificados dentro da função heatmap usando a ajuda
? heatmap

#Existem diversos argumentos da função heatmap, que podem ser modificados. Quando não definimos todos eles, a função utiliza o valor padrao (default)
#Veja que o primeiro argumento é x, a matriz com os dados a serem plotados. Como mat é o primeiro argumento, simplesemente omitimos
#Ou seja, no R, podemos seguir a ordem dos argumentos das funções, ou entao especificá-los (importante quando nao seguimos a ordem). Assim obtemos o mesmo resultado se fizermos:
heatmap (x = test)


#Observe que o R adiciona dendrogramas, agrupando os valores (clusterização). Podemos mudar os metodos de clusterização

#Para as linhas
drow <- dist(test, method = "euclidean") #escolher método (euclidian,maximum,manhattan,canberra,binary ou minkowski)
hrow <- hclust (drow, method = "average") #escolher método (single, complete, average, mcquitty, median ou centroid)

#Para as colunas
dcol<-dist(t(test), method = "euclidean")
hcol<-hclust(dcol, method = "average")


#Plotando o heatmap
heatmap(test,
        Rowv = as.dendrogram(hrow),
        Colv = as.dendrogram(hcol)
        )


#Podemos trocar as cores do heatmap, criando uma paleta de cores

pal <- colorRampPalette(c("lightblue","white", "darkblue" ))(n=299)

heatmap(test,
        Rowv = as.dendrogram(hrow),
        Colv = as.dendrogram(hcol),
        col = pal
        )

# O R possui algumas paletas prontas que você pode usar
heatmap(test,
        Rowv = as.dendrogram(hrow),
        Colv = as.dendrogram(hcol),
        col = topo.colors(299)
        )
#Além de topo.colors, existem outros que você pode testar como rainbow(), terrain.color(), heat.colors(),cm.colors()

#Ou voce pode usar as paletas do pacote Rcolorbrewer, que traz várias opções mais elegantes
library(RColorBrewer)
heatmap(test,
        Rowv = as.dendrogram(hrow),
        Colv = as.dendrogram(hcol),
        col = brewer.pal(8,"Greens")
        )
#Veja as opções disponiveis com o código abaixo
display.brewer.all()
