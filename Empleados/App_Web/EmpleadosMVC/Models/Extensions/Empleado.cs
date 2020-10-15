using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Web.Mvc;
using EmpleadosMVC.Utilitys;

namespace EmpleadosMVC.Models
{
    [MetadataType(typeof(Empleado.MetaData))]
    [DisplayName("Empleados")]
    public partial class Empleado
    {
        private sealed class MetaData
        {
            [Required, DisplayName("ID Empleado"), StringLength(50)]
            public Int32 ID { get; set; }

            [Required, DisplayName("DNI"), StringLength(200)]
            public String DNI { get; set; }

            [Required, DisplayName("Nombre de Empleado"), StringLength(200)]
            public String Nombre { get; set; }

            [Required, DisplayName("Telefono del Empleado"), StringLength(200)]
            public String Telefono { get; set; }

            [DisplayName("Correo del Empleado"), StringLength(200)]
            public String Correo { get; set; }

            [DisplayName("Direccion del Empleado"), StringLength(200)]
            public String Direccion { get; set; }

            [Required, DisplayName("Sueldo"), StringLength(10)]
            public Double Sueldo { get; set; }

            [Required, DisplayName("Sueldo Anual"), StringLength(10)]
            public Double SueldoAnual { get; set; }

            [Required, DisplayName("Estatus")]
            public int Estatus { get; set; }

            [Required, DisplayName("Tipo Contrato")]
            public TipoContracto TipoContracto { get; set; }

        }

        #region Metodos Extendidos del Entities Framework

        public SelectList ToEntitySelectList()
        {
            return ToSelectList();
        }

        public static SelectList ToSelectList()
        {
            return new SelectList(new EmpleadosMVC.Models.DemoEmpleadosEntities().EmpleadoSet.ToList(), "ID", "Nombre");
        }

        public static SelectList ToEmpleadoDNISelectList()
        {
            return new SelectList(new EmpleadosMVC.Models.DemoEmpleadosEntities().EmpleadoSet.ToList(), "ID", "DNI");
        }

        public TipoContracto TipoContractoLoad()
        {
            return Utility.Entity<TipoContracto>.LoadReference(this.TipoContractoReference);
        }

        #endregion
    }
}