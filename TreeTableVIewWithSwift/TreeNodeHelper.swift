//
//  TreeNodeHelper.swift
//  TreeTableVIewWithSwift
//

import Foundation


class TreeNodeHelper {
    
    //Singleton mode
    class var sharedInstance: TreeNodeHelper {
        struct Static {
            static var instance: TreeNodeHelper? = TreeNodeHelper()
        }
        return Static.instance!
    }
    
    
    //Pass in the normal node and convert it into sorted Node
    func getSortedNodes(_ groups: NSMutableArray, defaultExpandLevel: Int) -> [TreeNode] {
        var result: [TreeNode] = []
        let nodes = convetData2Node(groups)
        let rootNodes = getRootNodes(nodes)
        for item in rootNodes{
            addNode(&result, node: item, defaultExpandLeval: defaultExpandLevel, currentLevel: 1)
        }
        
        return result
    }
    
    //Filter out all visible nodes
    func filterVisibleNode(_ nodes: [TreeNode]) -> [TreeNode] {
        var result: [TreeNode] = []
        for item in nodes {
            if item.isRoot() || item.isParentExpand() {
                setNodeIcon(item)
                result.append(item)
            }
        }
        return result
    }
    
    //Convert data to book nodes
    func convetData2Node(_ groups: NSMutableArray) -> [TreeNode] {
        var nodes: [TreeNode] = []
        
        var node: TreeNode
        var desc: String?
        var id: String?
        var pId: String?
        var label: String?
        
        for element in groups {
            let item = element as? [String:Any]
            desc = item?["description"] as? String
            id = item?["id"] as? String
            pId = item?["pid"] as? String
            label = item?["name"] as? String
            
            
            node = TreeNode(desc: desc, id: id, pId: pId, name: label)
            nodes.append(node)
        }
        
        /**
        * Set Node, parent-child relationship; let each two nodes compare once, you can set the relationship
        */
        var n: TreeNode
        var m: TreeNode
        for i in 0 ..< nodes.count {
            n = nodes[i]
            
            for j in i+1 ..< nodes.count {
                m = nodes[j]
                if m.pId == n.id {
                    n.children.append(m)
                    m.parent = n
                } else if n.pId == m.id {
                    m.children.append(n)
                    n.parent = m
                }
            }
        }
        for item in nodes {
            setNodeIcon(item)
        }
        
        return nodes
    }
    
    // Get root node set
    func getRootNodes(_ nodes: [TreeNode]) -> [TreeNode] {
        var root: [TreeNode] = []
        for item in nodes {
            if item.isRoot() {
                root.append(item)
            }
        }
        return root
    }
    
    //Hang all the child nodes of a node
    func addNode(_ nodes: inout [TreeNode], node: TreeNode, defaultExpandLeval: Int, currentLevel: Int) {
        nodes.append(node)
        if defaultExpandLeval >= currentLevel {
            node.setExpand(true)
        }
        if node.isLeaf() {
            return
        }
        for i in 0 ..< node.children.count {
            addNode(&nodes, node: node.children[i], defaultExpandLeval: defaultExpandLeval, currentLevel: currentLevel+1)
        }
    }
    
    // Set node icon
    func setNodeIcon(_ node: TreeNode) {
        if node.children.count > 0 {
            node.type = TreeNode.NODE_TYPE_G
            if node.isExpand {
                // Set icon to the down arrow
                node.icon = "tree_ex.png"
            } else if !node.isExpand {
                // Set icon to the right arrow
                node.icon = "tree_ec.png"
            }
        } else {
            node.type = TreeNode.NODE_TYPE_N
        }
    }
    
    
}
