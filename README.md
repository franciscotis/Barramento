# Barramento

## Integrantes do grupo

```
Francisco Tito Silva Santos Pereira
Sesaque Oliveira
```

## Instruções de Compilação
```
Inicialmente será necessário baixar a pasta do projeto, em seguida abrir o Quartus (Quartus Prime 18.1) Lite Edition, na qual foi a versão que o projeto foi feito.
Após abrir o Quartus, será necessário abrir o projeto que tem o nome de "P1.QPF"
Em seguida, para compilar, basta apertar no botão de compilar
```

## Instruções de passagem do processador para a placa FPGA
 ```
 Esse projeto já está configurado para o funcionamento na placa FPGA : Cyclone IV EP4CE6E22C8. Para passar o processador para a fpga basta ir em "Programmer" e passar o arquivo localizado em 'output_files/P1.sof' para a fpga.
 ```
 
 ## Instruções de passagem do programa em C para a placa FPGA
  ```
  Após passar o processador para a fpga, será necessário abrir o eclipse contendo os arquivos em C. Para isso, basta ir no Quartus em: 'Tools > Nios II Software Build Tools For Eclipse' assim irá abrir o eclipse. Ao abrir, será necessário importar os arquivos em C, que estão localizados na pasta 'software'. As pastas a serem importadas são P1 e P1_bsp.
  Após abrir as pastas, será necessário clicar com o botão direito em cima da pasta B1_bsp e ir em NIOS II > generate bsp. Isso irá fazer com que as configurações do hardware sejam acessadas via software.
  Em seguida, clicar com o botão direito em cima da pasta P1 e cicar em Build Project, assim, como o nome já diz, irá dar o Build no projeto. Logo, para passar para a fpga, é necessário clicar com o botão direito em cima da pasta P1> Run As> Nios II Hardware.
  Fazendo isso, o projeto irá passar para a placa.
   ```
