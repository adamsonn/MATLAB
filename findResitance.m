function [resistance] = findResitance(node, nodeArray)
    if (isnumeric(node.LeftChild)==1 && isnumeric(node.RightChild) == 1)
        resistance = node.Resistance;
    else
        leftChild = nodeArray(node.LeftChild.Index);
        rightChild = nodeArray(node.RightChild.Index);
        returnResit = 0;
        if (isnumeric(leftChild) ~= 1)
            returnResit = returnResit + leftChild.Resistance + findResitance(leftChild, nodeArray);
        end
        if (isnumeric(rightChild) ~= 1)
            returnResit = returnResit + rightChild.Resistance + findResitance(rightChild, nodeArray);
        end
        resistance = returnResit;
    end
end