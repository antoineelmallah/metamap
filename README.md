# Criação dos arquivos de internacionalização:

1. No terminal, entre no diretório ignored e execute o comando:

unzip umls-2022AB-full.zip

2. Renomeie a pasta descompactada para DUMLS

mv 2022AB-full DUMLS && cd DUMLS

3. Execute o comando:

unzip mmsys.zip

4. Execute:

ls -l 

e verifique que o arquivo "release.dat" encontra-se no diretório corrente (DUMLS). Caso não esteja, execute:

mv mmsys/release.dat .

5. Execute:

./run_linux.sh

Aparecerá uma aba do sistema Metamorphosys

6. Selecione aopção Install UMLS e selecione como fonte a pasta ./DUMLS/ e destino o caminho
../instalacao/ e deixe marcado apenas:

- Metathesaurus 
- Specialist Lexicon 

e escolha OK

7. Em seguida clique em New Configuration e escolha Accept

8. Escolha level 0 e OK

9. Na aba de Output Options verifique se está no formato Rich Release Format(RLF) senão mude para esse formato

10. Na aba de Source List, selecione a opção "Select sources to INCLUDE in subset" e selecione os seguintes vocabulários em português segurando Control:

- ICPCPOR_1993
- LNC-PT-BR_268
- MDRBPOR23_0 (cuidado nessa seleção, há também um parecido, mas é português de Portugal)
- MSHPOR2020
- WHOPOR_1997

Ao clicar em cada uma das opções, vai aparecer uma aba que sugere outros vocabulários que estão ligados a esses. É só clicar em Cancelar que
não serão incluídas. No final apenas estes 5 vocabulários devem estar com
linhas azuis

11. No topo da direita clique em Done e clique em Begin Subset

12. Salve e complete a configuração digitando um nome qualquer, para este caso
nomeei como "config-metamorphosys" e selecione Save

13. Quando terminar de carregar aperte OK. E saia do Metamorphosis. A insta-
lação demora aproximadamente 7 minutos.

# Execução do MetaMap:

1. Instale o docker

2. 
