#Criado por Amanda Fanelli em 04/2021
#Conteúdo disponivel no instagram amandafanelli_phd

#Para criar um heatmap ou mapa de calor no R, precisamos dos dados numéricos na forma de uma matriz

# Com as linhas abaixo, vamos gerar uma matriz e chamá-la de test, com os dados de exemplo (não se preocupe se nao entender essa parte)
set.seed(1)
test <- matrix(rnorm(300), 10, 4)
colnames(test) <- c("folha","raiz","caule","flor")
rownames(test) <- paste("Gene", LETTERS[seq(from = 1, to = 10)], sep = " ")

#Agora, para criar um heatmap basta utilizar a função heatmap(), usando a matriz test:
heatmap(test)

#Um argumento importante da função heatmap é o scale.
#Scale realiza um método estatístico para centralizar e escalonar os dados de uma matriz. Todos os números sao subtraídos da média (centralização) e divididos pelo desvio padrão, assim os dados ficam normalizados. 
#Isso pode ser feito coluna por coluna, ou linha por linha

#Observe como funciona a função scale do R (fora da função heatmap)
#informações na ajuda
?scale
#Perceba que para a função scale, o padrão é normalizar por coluna
#Aplicando para os nossos dados
scale_column <- scale(test)
View (scale_column)
#Os valores foram normalizados coluna por coluna (cada valor da coluna 1 foi subtraído da média da coluna 1 e dividido pelo desvio padrão da coluna 1, e assim por diante)

#Podemos normalizar por linha, basta transpor a matriz test usando a função t
scale_row <- scale(t(test))
View(scale_row)


#O parâmetro scale na função heatmap pode ser definido como "row" para aplicar o método de normalização linha por linha, "column" coluna por coluna, e "none" para não aplicar o método de normalização
#Por padrão, na função heatmap(), scale = "row". 
heatmap(test)

#Se quiser aplicar o método scale por colunas, utilize scale = "col"

heatmap(test,
        scale = "col")
#Neste caso do nosso exemplo, com os valores normalizados por coluna, destacamos a diferença dos valores de expressão entre os genes (linhas), para cada tecido (coluna).
#Com os valores normalizados por linha, destacamos a diferença entre os tecidos e não os genes.

#Se você não deseja aplicar nenhum tipo de normalização, seus dados já estão normalizados, preste atenção, você precisa modificar scale = "none"
heatmap(test,
        scale = "none")                                                                                                                                       
                                                                                                                                       
#Vale lembrar que a função heatmap realiza primeiro o agrupamento dos dados (cluster) e depois aplica o método do scale nos dados para modificar a escala de cores.
#O parâmetro scale dentro da função heatmap não influencia a clusterização
#Se você usa o pacote pheatmap, neste caso o padrão é scale = "none"
#Se você usa a função heatmap.2 do pacote gplots, neste caso o padrão também é scale = "none"

#Veja mais um exemplo da importância do parâmetro scale: Vamos analisar um conjunto de dados do R base, o mtcars
mat <- as.matrix(mtcars)
heatmap(mat, 
        scale ="none")

#Observe que os valores das colunas hp e disp são muito maiores do que os das demais colunas, e por isso dominam a escala de cores, não sendo possível notar diferença entre as demais colunas
#Vamos então aplicar scale = "column", para normalizar os dados coluna por coluna. Assim a diferença entre as duas últimas colunas e as demais não será mais tão grande
heatmap(mat, 
        scale ="column")

