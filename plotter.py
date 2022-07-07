#this is a helper module that converts a gcastle matrix to a graph
#Need to specify the data and give the gcastle resule, which is a tensor object
import networkx as nx

def myplot(df, X):
    G = nx.DiGraph()

    name_list = list(df)
    G.add_nodes_from(name_list)

    dimx = X.shape[0]
    for i in range(dimx):
        for j in range(dimx):
            if X[i,j] == 1 and G.has_edge(name_list[j], name_list[i]) == False:
                G.add_edge(name_list[i],name_list[j])

    nx.draw(G, pos = nx.circular_layout(G), with_labels = True, node_shape = "s", node_color = "none")
