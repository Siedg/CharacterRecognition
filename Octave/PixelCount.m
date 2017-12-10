pkg load image

function countPixels(img, file)
  black = 0;
  white = 0;
#  total = ((rows(img) * columns(img)) / 2);
  
  for r = 1 : rows(img) / 2
    for c = 1 : columns(img) / 2
      if (img(cast(r, "uint32"), (cast(c, "uint32"))) == 1)
        black++;
      else
        white++;  
      endif
    endfor
  endfor
  
  blackRatio = black / (rows(img) * columns(img)) * 100;
  whiteRatio = white / (rows(img) * columns(img)) * 100;  
  fprintf(file, "%.2f ", blackRatio);
  fprintf(file, "%.2f ", whiteRatio);
endfunction

function upperSide(img, file)
  black = 0;
  r = rows(img);
  c = columns(img);
  
  for i = 1 : r / 2
    for j = 1 : c
      if (img(cast(i, "uint32"), (cast(j, "uint32"))) == 1)
        black++;
      endif
    endfor
  endfor

  blackRatio = black / (rows(img) * columns(img)) / 2 * 100;
  fprintf(file, "%.2f ", blackRatio);
endfunction

function leftSide(img, file)
  black = 0;
  
  for i = 1 : rows(img)
    for j = 1 : columns(img) / 2
      if (img(cast(i, "uint32"), (cast(j, "uint32"))) == 1)
        black++;
      endif
    endfor
  endfor

  blackRatio = black / (rows(img) * columns(img)) / 2 * 100;
  fprintf(file, "%.2f ", blackRatio);
endfunction 

function horizontalHistogram(img, file)
  black = 0;
  
  for i = (rows(img) / 2) - 1 : (rows(img) / 2) + 1
    for j = 1 : columns(img)
      if (img(cast(i, "uint32"), (cast(j, "uint32"))) == 1)
        black++;
      endif
    endfor
  endfor
  
  blackRatio = black / (rows(img) * columns(img)) * 100;
  fprintf(file, "%.2f ", blackRatio);
endfunction

function verticalHistogram(img, file)
  black = 0;
  
  for i = rows(img)
    for j = 1 : (columns(img) / 2) - 1 : (columns(img) / 2) + 1
      if (img(cast(i, "uint32"), (cast(j, "uint32"))) == 1)
        black++;
      endif
    endfor
  endfor
  
  blackRatio = black / (rows(img) * columns(img)) * 100;
  fprintf(file, "%.2f ", blackRatio);
endfunction

function totalRatio(img, file)
  ratio = 4;
  r = rows(img);
  c = columns(img);
  
  rPointer = [0];
  cPointer = [0];
  black = 0;
  blackPointer = [];
  
  for i = 2 : ratio
    rPointer(end + 1, :) = floor((rPointer(end) + r / ratio)) - 1;
    cPointer(end + 1, :) = floor((cPointer(end) + c / ratio)) - 1;
  endfor
  
  rPointer(end + 1, :) = r;
  cPointer(end + 1, :) = c;
  
  for i = 1 : ratio
    for j = 1 : ratio
      for k = rPointer(i) + 1 : rPointer(i + 1)
        for l = cPointer(j) + 1 : cPointer(j + 1)
          if img(k, l) == 1
            black++;
          endif
        endfor  
      endfor   
      blackPointer(end + 1, :) = black;
      black = 0;
    endfor
  endfor
  
  for i = 1 : size(blackPointer)
    blackPointer(i) = blackPointer(i) / r * c * 100;
    #fprintf(file, "%.2f ", blackPointer(i));
  endfor

  for i = 1 : size(blackPointer)
    fprintf(file, "%.2f ", blackPointer(i));
  endfor  
endfunction

################################################################################
#inputFile = fopen("C:\Users\Siedg\Dropbox\Documentos\IA\CharacterRecognizer\NCharacter_SD19_BMP\NIST_Test_Upper.txt");
inputFile = fopen("./TrainTest/NIST_Train_Upper.txt");
outputFile = fopen("output.txt", "w");


printf("Start while \n");
cycle = 0;
while ~feof(inputFile)
  printf("%d \n", cycle);
  cycle++;
  rowContent = fscanf(inputFile, "%s", 1);
  if ~isempty(rowContent)
    #file = strcat("C:\Users\Siedg\Dropbox\Documentos\IA\CharacterRecognizer\NCharacter_SD19_BMP", rowContent);
    file = strcat("./NCharacter_SD19_BMP", rowContent);
    img = imread(file);
    
    countPixels(img, outputFile);
    upperSide(img, outputFile);
    leftSide(img, outputFile);
    totalRatio(img, outputFile);
    horizontalHistogram(img, outputFile);
    verticalHistogram(img, outputFile);
    
    switch(rowContent(2))
      case("a")
        fprintf(outputFile, "0.00");
      case("b")
        fprintf(outputFile, "1.00");
      case("c")
        fprintf(outputFile, "2.00");
      case("d")
        fprintf(outputFile, "3.00");
      case("e")
        fprintf(outputFile, "4.00");
      case("f")
        fprintf(outputFile, "5.00");
      case("g")
        fprintf(outputFile, "6.00");
      case("h")
        fprintf(outputFile, "7.00");
      case("i")
        fprintf(outputFile, "8.00");
      case("j")
        fprintf(outputFile, "9.00");
      case("k")
        fprintf(outputFile, "10.00");
      case("l")
        fprintf(outputFile, "11.00");
      case("m")
        fprintf(outputFile, "12.00");
      case("n")
        fprintf(outputFile, "13.00");
      case("o")
        fprintf(outputFile, "14.00");
      case("p")
        fprintf(outputFile, "15.00");
      case("q")
        fprintf(outputFile, "16.00");
      case("r")
        fprintf(outputFile, "17.00");
      case("s")
        fprintf(outputFile, "18.00");
      case("t")
        fprintf(outputFile, "19.00");
      case("u")
        fprintf(outputFile, "20.00");
      case("v")
        fprintf(outputFile, "21.00");
      case("w")
        fprintf(outputFile, "22.00");
      case("x")
        fprintf(outputFile, "23.00");
      case("y")
        fprintf(outputFile, "24.00");
      case("z")
        fprintf(outputFile, "25.00");  
      otherwise
        printf("Otherwise \n");
    endswitch
    
    fprintf(outputFile, "\n");
  endif
endwhile

fclose(inputFile);
fclose(outputFile);

printf("Finished \n");  
    
        
    