package modelo;

public class Usuario {

    private String  usuario;
    private String  clave;
    private String  nombre;
    private String  correo;
    private boolean validar;
    private String  status;
    private boolean esAdmin;
    private String  fechaRegistro;

    public Usuario() {}

    public String  getUsuario()               { return usuario; }
    public void    setUsuario(String u)       { this.usuario = u; }

    public String  getClave()                 { return clave; }
    public void    setClave(String c)         { this.clave = c; }

    public String  getNombre()                { return nombre; }
    public void    setNombre(String n)        { this.nombre = n; }

    public String  getCorreo()                { return correo; }
    public void    setCorreo(String c)        { this.correo = c; }

    public boolean isValidar()                { return validar; }
    public void    setValidar(boolean v)      { this.validar = v; }

    public String  getStatus()                { return status; }
    public void    setStatus(String s)        { this.status = s; }

    public boolean isEsAdmin()                { return esAdmin; }
    public void    setEsAdmin(boolean a)      { this.esAdmin = a; }

    public String  getFechaRegistro()         { return fechaRegistro; }
    public void    setFechaRegistro(String f) { this.fechaRegistro = f; }
}
