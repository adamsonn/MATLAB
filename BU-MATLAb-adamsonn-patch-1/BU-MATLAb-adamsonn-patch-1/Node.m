classdef Node
    
    % A Tree structure for tracking probabilities of of escape through  a
    % binary tree
    %   Detailed explanation goes here
    
   properties
      Diameter
      Length
      alpha
      beta
      gamma
      Parent
      LeftChild
      RightChild
      Resistance
      Flow
      Index
   end
   
       methods
        function obj = Node(diameter, parent, leftChild, rightChild, index, Length, alpha, beta, gamma)
            obj.Diameter = diameter;
            obj.Parent = parent;
            obj.LeftChild = leftChild;
            obj.RightChild = rightChild;
            obj.Index = index;
            obj.Length = Length;
            obj.alpha = alpha;
            obj.beta = beta;
            obj.gamma = gamma;
            obj.Resistance= Length/(diameter)^4;
        end
        
        function probablity = getProbability(node, flow)
             probablity = abs(real(SingleBifucprop(flow,node.Length*10^-2,node.Diameter*10^-2,node.gamma,node.Parent.Diameter)));
        end
    end
end
