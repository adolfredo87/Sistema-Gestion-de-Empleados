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
    [MetadataType(typeof(TipoContracto.MetaData))]
    [DisplayName("TipoContracto")]
    public partial class TipoContracto
    {
        private sealed class MetaData
        {
            [Required, DisplayName("ID"), StringLength(50)]
            public int ID { get; set; }

            [Required, DisplayName("Codigo"), StringLength(50)]
            public String Codigo { get; set; }

            [Required, DisplayName("Tipo"), StringLength(100)]
            public String Descripcion { get; set; }

            [Required, DisplayName("Multiplo"), StringLength(100)]
            public String MultiploAnual { get; set; }

            [Required, DisplayName("Estatus")]
            public int Estatus { get; set; }

        }

        #region Metodos Extendidos del Entities Framework

        public SelectList ToEntitySelectList()
        {
            return ToSelectList();
        }

        public static SelectList ToSelectList()
        {
            return new SelectList(new EmpleadosMVC.Models.DemoEmpleadosEntities().TipoContractoSet.ToList(), "ID", "Descripcion");
        }

        #endregion
    }
}