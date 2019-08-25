function [children] = findChildren(node, nodeArray)
    disp(node);
    if (isnumeric(node.LeftChild)==1 && isnumeric(node.RightChild) == 1)
        children = 1;
    else
        children = 1 + findChildren(nodeArray(node.LeftChild.Index), nodeArray) + findChildren(nodeArray(node.RightChild.Index), nodeArray);
    end
end