﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace EmpleadosMVC.Utilitys
{
    public class JsonHandleErrorAttribute : FilterAttribute, IExceptionFilter
    {
        public void OnException(ExceptionContext filterContext)
        {
            filterContext.ExceptionHandled = true;
            filterContext.Result = new JsonResult
            {
                Data = new { 
                    success = false, 
                    error = filterContext.Exception.Message.ToString(),
                    clientMessage = filterContext.Exception.Message,
                    stackTrace = filterContext.Exception.StackTrace,
                    codError = "501"
                },
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
        }
    }
}
