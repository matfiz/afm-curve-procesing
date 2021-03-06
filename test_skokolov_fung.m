close all;
clear all;
clc;
load('D:\Brzezinka\Dokumenty\doktoranckie\JPK\curve_processing\tmp\urve.mat');

elasticityParams = curve.elasticityParams;
    stiffnessParams = curve.stiffnessParams;
    %I search for index of contact point in Z-pos data CP taken from
    %stiffness FI curve, ie the first CP
    index = find(curve.dataHeightMeasured == elasticityParams.xContactPoint);
    %it returns to values (for approach and retrace), I take the first
    %(approach)
    xContactPointIndex = index(1);
    %how much the force was shifted
    forceShift = 2.6912e-10;
    %calculate a
    a=FunctionFungHyperelasticIndentation(elasticityParams.radius, elasticityParams.dataIndentation);
    force=FunctionFungHyperelastic([elasticityParams.radius 0.5], [elasticityParams.E elasticityParams.b elasticityParams.y0], a)+forceShift;
    dModel = [];
    for i=1:length(curve.stiffnessParams.dataForce),
         indentation(i) = FunctionValueInverseFungHyperelastic([elasticityParams.radius 0.5], [elasticityParams.E elasticityParams.b elasticityParams.y0], stiffnessParams.dataForce(i));
         stiffnessParams.dataH(i) = curve.dataHeightMeasured(xContactPointIndex+i-1) - curve.dataHeightMeasured(xContactPointIndex) + indentation(i) + stiffnessParams.dataForce(i)/curve.scalingFactor;
         %dModel(i) = 
    end
    %plot(stiffnessParams.dataH,stiffnessParams.dataIndentation);
    %set(gca,'YScale','log');
    fd = curve.force_distance_approach;
    plot(fd(1,:),fd(2,:)/curve.scalingFactor*10^9,fd(1,xContactPointIndex:end),force/curve.scalingFactor*10^9);