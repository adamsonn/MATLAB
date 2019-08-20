function [flow] = findFlow(initialFlow,node, nodeArray)
    persistent returnString;
    if isempty(returnString)
        returnString='';
    end
    if (isnumeric(node.LeftChild)==1 && isnumeric(node.RightChild) == 1)
        returnString = [returnString,sprintf('%d,%f,\n', node.Index, initialFlow)];
        %fprintf('%d,%f\n', node.Index, initialFlow);
        flow = initialFlow;
    else
        leftChild = nodeArray(node.LeftChild.Index);
        rightChild = nodeArray(node.RightChild.Index);
        leftResistance = findResitance(leftChild, nodeArray);
        rightResistance = findResitance(rightChild, nodeArray);
        rightFlow = initialFlow * (leftResistance/(rightResistance + leftResistance));
        leftFlow = initialFlow * (rightResistance/(rightResistance + leftResistance));
        retFlow = findFlow(...
            leftFlow, nodeArray(node.LeftChild.Index), nodeArray) +  ... %explore left
            findFlow(rightFlow,nodeArray(node.RightChild.Index), nodeArray); % explore right
        node.Flow = retFlow;
        %fprintf('%d,%f\n', node.Index, retFlow);
        returnString = [returnString,sprintf('%d,%f,\n', node.Index, initialFlow)];
        if (node.Index==1)
            fprintf(returnString);
            retFlow = returnString;
        end
        flow = retFlow;
    end
end