module {
    public type Platillo = {
        idPlatillo : Nat;
        nombre : Text;
        precio : Nat;
        descripcion : Text;
    };

    public type Pedido = {
        platillos : [Platillo];
        total : Nat;
    };

    public type Mesa = {
        idMesa : Nat;
        capacidad : Nat;
        ocupada : Bool;
        cuenta : Pedido;
    };

};
