#!wolframscript

getRegionSAS[sas_] := And @@ (GreaterEqual[#, 0] & /@ sas);
verifyResults[benchmark_, plot_, plotRange_, verifyTimeLimit_] := 
 Module[
  {systemPath, xvarSet, yvarSet, zvarSet, s1, s2, hPath, hData, h, 
   hHomo, sdpTime, verifyTime, totalTime, result, flag, flagHomo, 
   flagNP, hNP, i},
  systemPath = 
   FileNameJoin[{".", "Results", "problem", 
     StringJoin[benchmark, ".txt"]}];
  
  {xvarSet, yvarSet, zvarSet, s1, s2} = ReadList[systemPath];
  
  flag = 1;
  
  hPath = 
   FileNameJoin[{".", "Results", "sufficient", 
     StringJoin[benchmark, ".txt"]}];
  If[FileExistsQ[hPath],
   hData = 
    ReadList[hPath, {Expression, Expression}, 
     RecordSeparators -> "\n"];
   Print["===== Verifying polynomial interpolants (CAV20 method) \
====="];
   h = hData[[1]][[1]];
   sdpTime = hData[[1]][[2]];
   result = 
    Timing[TimeConstrained[
      myVerify[xvarSet, yvarSet, zvarSet, s1, s2, h], verifyTimeLimit,
       2]];
   verifyTime = result[[1]];
   totalTime = sdpTime + verifyTime;
   If[result[[2]] == 0,
    Print["Numerical Errors Detected."];
    flag = 0;
    ];
   If[result[[2]] == 1,
    Print["Valid solution."];
    ];
   If[result[[2]] == 2,
    Print["Verify out of time."];
    ];
   Print["SDP Time: ", sdpTime ];
   Print["verify Time: ", verifyTime ];
   Print["Total Time: ", totalTime ];,
   flag = 0;
   ];
  
  hPath = 
   FileNameJoin[{".", "Results", "homo", 
     StringJoin[benchmark, ".txt"]}];
  If[FileExistsQ[hPath],
   Print["===== Verifying polynomial interpolants (our method) ====="];
   hData = 
    ReadList[hPath, {Expression, Expression}, 
     RecordSeparators -> "\n"];
   flagHomo = 1;
   hHomo = hData[[1]][[1]];
   sdpTime = hData[[1]][[2]];
   result = 
    Timing[TimeConstrained[
      myVerifyHomo[xvarSet, yvarSet, zvarSet, s1, s2, hHomo], 
      verifyTimeLimit, 2]];
   verifyTime = result[[1]];
   totalTime = sdpTime + verifyTime;
   If[result[[2]] == 0,
    Print["Numerical Errors Detected."];
    ];
   If[result[[2]] == 1,
    Print["Valid solution."];
    ];
   If[result[[2]] == 2,
    Print["Verify out of time."];
    ];
   Print["SDP Time: ", sdpTime ];
   Print["verify Time: ", verifyTime ];
   Print["Total Time: ", totalTime ];,
   flagHomo = 1;
   ];
  
  hPath = 
   FileNameJoin[{".", "Results", "nonpoly", 
     StringJoin[benchmark, ".txt"]}];
  If[FileExistsQ[hPath], 
   Print["===== Verifying semialgebraic interpolants (our method) \
====="];
   hData = 
    ReadList[hPath, {Expression, Expression}, 
     RecordSeparators -> "\n"];
   flagNP = 1;
   hNP = hData[[1]][[1]];
   sdpTime = hData[[1]][[2]];
   result = 
    Timing[TimeConstrained[
      myVerifySemi[xvarSet, yvarSet, zvarSet, s1, s2, hNP], 
      verifyTimeLimit, 2]];
   verifyTime = result[[1]];
   totalTime = sdpTime + verifyTime;
   If[result[[2]] == 0,
    Print["Numerical Errors Detected."];
    flagNP = 0
    ];
   If[result[[2]] == 1,
    Print["Valid solution."];
    ];
   If[result[[2]] == 2,
    Print["Verify out of time."];
    ];
   Print["SDP Time: ", sdpTime ];
   Print["verify Time: ", verifyTime ];
   Print["Total Time: ", totalTime ];,
   flagNP = 0;
   ];
  
  If[ plot == 1,
   If[Length[xvarSet] == 2, 
    myPlot2D[benchmark, xvarSet, yvarSet, zvarSet, plotRange, s1, s2, 
     If[flag == 0, -1, h], If[flagHomo == 0, -1, hHomo], 
     If[flagNP == 0, -1, hNP]]];
   If[Length[xvarSet] == 3, 
    myPlot3D[benchmark, xvarSet, yvarSet, zvarSet, plotRange, s1, s2, 
     If[flag == 0, -1, h], If[flagHomo == 0, -1, hHomo], 
     If[flagNP == 0, -1, hNP]]];
   ]
  ]

myVerify [xvarSet_, yvarSet_, zvarSet_, s1_, s2_, h_] := Module[
  {lambda, s1Cons, s2Cons, bcLie, cond1, cond2, timev},
  timev = Now;
  s1Cons = Or @@ (getRegionSAS[#] & /@ s1);
  s2Cons = Or @@ (getRegionSAS[#] & /@ s2);
  cond1 = 
   FindInstance[h - 1 < 0 && s1Cons, Join[xvarSet, yvarSet], Reals];
  cond2 = 
   FindInstance[-h - 1 < 0 && s2Cons, Join[xvarSet, zvarSet], Reals];
  If[Length[cond1] + Length[cond2] == 0, (*no counter-
   example is found*)
   Return[1],
   Return[0]];
  
  ]
myVerifyHomo [xvarSet_, yvarSet_, zvarSet_, s1_, s2_, hHomo_] := 
 Module[
  {lambda, s1Cons, s2Cons, bcLie, cond1, cond2, timev},
  timev = Now;
  s1Cons = Or @@ (getRegionSAS[#] & /@ s1);
  s2Cons = Or @@ (getRegionSAS[#] & /@ s2);
  cond1 = 
   FindInstance[hHomo <=  0 && s1Cons, Join[xvarSet, yvarSet], Reals];
  cond2 = 
   FindInstance[-hHomo <=  0 && s2Cons, Join[xvarSet, zvarSet], Reals];
  If[Length[cond1] + Length[cond2] == 0, (*no counter-
   example is found*)
   Return[1],
   Return[0]];
  ]
myVerifySemi [xvarSet_, yvarSet_, zvarSet_, s1_, s2_, hHomo_] := 
 Module[
  {lambda, s1Cons, s2Cons, bcLie, cond1, cond2, timev},
  timev = Now;
  s1Cons = Or @@ (getRegionSAS[#] & /@ s1);
  s2Cons = Or @@ (getRegionSAS[#] & /@ s2);
  cond1 = 
   FindInstance[
    hHomo <=  0 && s1Cons && w >= 0 && w^2 == Total[xvarSet^2], 
    Join[xvarSet, yvarSet, {w}], Reals];
  cond2 = 
   FindInstance[-hHomo <=  0 && s2Cons && w >= 0 && 
     w^2 == Total[xvarSet^2], Join[xvarSet, zvarSet, {w}], Reals];
  If[Length[cond1] + Length[cond2] == 0, (*no counter-
   example is found*)
   Return[1],
   Return[0]];
  ]
myPlot2D [benchmark_, xvarSet_, yvarSet_, zvarSet_, xvarRange_, s1_, 
  s2_, h_, hHomo_, hNP_] := Module[
  {ranges, s1Cons, s2Cons, s1Plot, s2Plot, hPlot, hHomoPlot, hNPPlot},
  Print["Plot2d..."];
  ranges = Sequence @@ MapThread[Prepend, {xvarRange, xvarSet}];
  s1Cons = Or @@ (getRegionSAS[#] & /@ s1);
  s2Cons = Or @@ (getRegionSAS[#] & /@ s2);
  s1Plot = 
   RegionPlot[Resolve[Exists[yvarSet, s1Cons], Reals], 
    Evaluate[ranges], 
    PlotStyle -> {Opacity[0.65], RGBColor[
      0.28026441037696703`, 0.715, 0.4292089322474965]}, 
    BoundaryStyle -> None , PlotPoints -> 100];
  s2Plot = 
   RegionPlot[Resolve[Exists[zvarSet, s2Cons], Reals], 
    Evaluate[ranges], 
    PlotStyle -> {Opacity[0.65], RGBColor[0.915, 0.3325, 0.2125]}, 
    BoundaryStyle -> None, PlotPoints -> 100];
  
  hPlot = 
   RegionPlot[h - 1 >=  0, Evaluate[ranges], 
    PlotStyle -> {Opacity[0.15], RGBColor[1, 0.75, 0]}, 
    BoundaryStyle -> {
RGBColor[1, 0.75, 0]}, PlotPoints -> 100];
  hHomoPlot = 
   RegionPlot[hHomo >= 0, Evaluate[ranges], 
    PlotStyle -> {Opacity[0.15], RGBColor[
      0.363898, 0.618501, 0.782349]}, BoundaryStyle -> {
RGBColor[0.363898, 0.618501, 0.782349]}, PlotPoints -> 100];
  hNPPlot = 
   RegionPlot[ ReplaceAll[hNP, w -> Sqrt[Total[xvarSet^2]]] >= 0, 
    Evaluate[ranges], 
    PlotStyle -> {Opacity[0.15], RGBColor[
      0.363898, 0.618501, 0.782349]}, BoundaryStyle -> {
RGBColor[0.363898, 0.618501, 0.782349]}, PlotPoints -> 100];
  Export[FileNameJoin[{".", "Results", "plots", 
     StringJoin[benchmark, ".pdf"]}], 
   Show[s1Plot, s2Plot, hPlot, hHomoPlot, hNPPlot, 
    FrameLabel -> xvarSet]];
  ]

myPlot3D [benchmark_, xvarSet_, yvarSet_, zvarSet_, xvarRange_, s1_, 
   s2_, h_, hHomo_, hNP_] := Module[
   {ranges, s1Cons, s2Cons, s1Plot, s2Plot, hPlot, hHomoPlot},
   (*inefficient, try other tools*)
   Print["Plot3D..."];
   ranges = Sequence @@ MapThread[Prepend, {xvarRange, xvarSet}];
   ranges = Sequence @@ MapThread[Prepend, {xvarRange, xvarSet}];
   s1Cons = Or @@ (getRegionSAS[#] & /@ s1);
   s2Cons = Or @@ (getRegionSAS[#] & /@ s2);
   s1Plot = 
    RegionPlot3D[Resolve[Exists[yvarSet, s1Cons], Reals], 
     Evaluate[ranges], 
     PlotStyle -> {Opacity[0.65], RGBColor[
       0.28026441037696703`, 0.715, 0.4292089322474965]}, 
     BoundaryStyle -> None , PlotPoints -> 100];
   s2Plot = 
    RegionPlot3D[Resolve[Exists[zvarSet, s2Cons], Reals], 
     Evaluate[ranges], 
     PlotStyle -> {Opacity[0.65], RGBColor[0.915, 0.3325, 0.2125]}, 
     BoundaryStyle -> None, PlotPoints -> 100];
   hPlot = 
    RegionPlot3D[h - 1 >=  0, Evaluate[ranges], 
     PlotStyle -> {Opacity[0.15], RGBColor[1, 0.75, 0]}, 
     BoundaryStyle -> {
RGBColor[1, 0.75, 0]}, PlotPoints -> 100];
   hHomoPlot = 
    RegionPlot3D[hHomo >= 0, Evaluate[ranges], 
     PlotStyle -> {Opacity[0.15], RGBColor[
       0.363898, 0.618501, 0.782349]}, BoundaryStyle -> {
RGBColor[0.363898, 0.618501, 0.782349]}, PlotPoints -> 100];
   Export[
    FileNameJoin[{".", "Results", "plots", 
      StringJoin[benchmark, ".pdf"]}], 
    Show[s1Plot, s2Plot, hPlot, hHomoPlot, FrameLabel -> xvarSet]]
   ];

benchmarkname = "ex2";
Print["Benchmark:", benchmarkname];
verifytimelimit = 60; (*verification time limit*)
plot = 1; (*whether to plot(=1) or not (=0), better choose 2D \
examples*)
plotRange = {{-4, 4}, {-4, 4}}; (*range for plot*)
verifyResults[benchmarkname, plot, plotRange, verifytimelimit];


benchmarkname = "ex3";
Print["Benchmark:", benchmarkname];
verifytimelimit = 60; (*verification time limit*)
plot = 1; (*whether to plot(=1) or not (=0), better choose 2D \
examples*)
plotRange = {{-4, 4}, {-4, 4}}; (*range for plot*)
verifyResults[benchmarkname, plot, plotRange, verifytimelimit];

benchmarkname = "ex4";
Print["Benchmark:", benchmarkname];
verifytimelimit = 60; (*verification time limit*)
plot = 1; (*whether to plot(=1) or not (=0), better choose 2D \
examples*)
plotRange = {{-7, 7}, {-7, 7}, {-7, 7}}; (*range for plot*)
verifyResults[benchmarkname, plot, plotRange, verifytimelimit];