classdef Node
    
    % A Tree structure for tracking probabilities of of escape through  a
    % binary tree
    %   Detailed explanation goes here
    
   properties
      Diameter
      Length
      alpha
      beta
      gama
      Parent
      LeftChild
      RightChild
      Resistance
      Flow
      Index
   end
   
       methods
        function obj = Node(diameter, parent, leftChild, rightChild, index, Length, alpha, beta, gama)
            obj.Diameter = diameter;
            obj.Parent = parent;
            obj.LeftChild = leftChild;
            obj.RightChild = rightChild;
            obj.Index = index;
            obj.Length = Length;
            obj.alpha = alpha;
            obj.beta = beta;
            obj.gama = gama;
            obj.Resistance= Length/(diameter)^4;
        end
    end
end
