using System;
using System.Text;
using System.Reflection;
using System.Runtime.InteropServices;
using System.ComponentModel;

using Microsoft.Win32;


namespace Adds
{
    public partial class OraFunctions
    {
        /// <summary>
        /// Preforms the entire Oracle password login process, but does not build the SQL role statement.
        /// </summary>
        /// <param name="UserId"></param>
        /// <param name="Password"></param>
        /// <param name="DBConnectString"></param>
        /// <param name="DBSelection"></param>
        /// <param name="IniFileName"></param>
        /// <param name="AppName"></param>
        /// <param name="ErrorMessage"></param>
        /// <param name="StatusCode"></param>
        /// <returns></returns>
        [DllImport("LGORA32.DLL", EntryPoint = "#2", CallingConvention=CallingConvention.Cdecl)]
        public static extern int OracleDoUserLogin(StringBuilder UserId, StringBuilder Password,
            StringBuilder DBConnectString, StringBuilder DBSelection, StringBuilder IniFileName, 
            StringBuilder AppName, StringBuilder ErrorMessage, ref int StatusCode);

        /// <summary>
        /// Performs the entire Oracle password login process, and generates the SQL roles.
        /// </summary>
        /// <param name="UserId"></param>
        /// <param name="Password"></param>
        /// <param name="DBConnectString"></param>
        /// <param name="DBSelection"></param>
        /// <param name="IniFileName"></param>
        /// <param name="AppName"></param>
        /// <param name="AppID"></param>
        /// <param name="SecLevel"></param>
        /// <param name="RoleStatement"></param>
        /// <param name="ErrorMessage"></param>
        /// <param name="StatusCode"></param>
        /// <param name="HideDatabase"></param>
        /// <returns></returns>
        [DllImport("LGORA32.DLL", EntryPoint = "#8", CallingConvention = CallingConvention.Cdecl)]
                public static extern int OracleDoLoginProcess(StringBuilder UserId, StringBuilder Password, 
                    StringBuilder DBConnectString, StringBuilder DBSelection, StringBuilder IniFileName, 
                    StringBuilder AppName, StringBuilder AppID, StringBuilder SecLevel, StringBuilder RoleStatement, 
                    StringBuilder ErrorMessage, ref int StatusCode, bool HideDatabase);
    }
    
    public class OraLogin
    {
        public static string AppID = string.Empty;
        public static string AppName = string.Empty;
        public static string DBConnectString = string.Empty;
        public static string DBSelection = string.Empty;
        public static string ErrorMessage = string.Empty;
        public static string IniFileName = string.Empty;
        public static string Password = string.Empty;
        public static string RoleStatement = string.Empty;
        public static string SecLevel = string.Empty;
        public static string UserId = string.Empty;

        public int StatusCode;
        public bool HideDatabase;

        public enum tLogin
        {
            DO_LOGIN_PROCESS = 0,
            DO_USER_LOGIN = 1
        }

        public  static bool Login(string app_id, string app_name, string ini_file, tLogin login_type)
        {
            StringBuilder sbAppID = new StringBuilder(10);
            StringBuilder sbAppName = new StringBuilder(20);
            StringBuilder sbDBConn = new StringBuilder(44);
            StringBuilder sbDBSelection = new StringBuilder("ADDSDB", 30);
            //StringBuilder sbDBSelection = new StringBuilder(30);
            StringBuilder sbErrorMessage = new StringBuilder(90);
            StringBuilder sbIniFileName = new StringBuilder(1024);
            StringBuilder sbPassword = new StringBuilder(8);
            StringBuilder sbRoleStatement = new StringBuilder(500);
            StringBuilder sbSecLevel = new StringBuilder(30);
            StringBuilder sbUserID = new StringBuilder(8);

            int iStatusCode = -1;
            int nretcode = -1;
            bool bHideDatabase = false;
            try
            {

            if (app_id.Trim().Length != 0)
            {
                AppID = app_id;
                sbAppID.Append(AppID);
            }
            if (app_name.Trim().Length != 0)
            {
                AppName = app_name;
                sbAppName.Append(AppName);
            }
            if (ini_file.Trim().Length != 0)
            {
                IniFileName = ini_file;
                sbIniFileName.Append(IniFileName.Trim());
            }

            
            if (sbAppName.Length == 0 || sbIniFileName.Length == 0)
            {
                return false;
            }
            
                if (login_type == tLogin.DO_LOGIN_PROCESS)
                {
                    nretcode = OraFunctions.OracleDoLoginProcess(sbUserID, sbPassword, sbDBConn, sbDBSelection, 
                        sbIniFileName, sbAppName, sbAppID, sbSecLevel, sbRoleStatement, sbErrorMessage, 
                        ref iStatusCode, bHideDatabase);
                }
                else
                {
                    nretcode = OraFunctions.OracleDoUserLogin(sbUserID, sbPassword, sbDBConn, sbDBSelection, 
                            sbIniFileName, sbAppName, sbErrorMessage, ref iStatusCode);
                }

                if (nretcode <= 0 || nretcode > 2 )
                {
                    string sErrorMessage = DecodeReturnValue(nretcode, iStatusCode);
                    throw new ApplicationException(sErrorMessage);
                }
                else
                {
                    UserId = sbUserID.ToString().Trim();
                    Password = sbPassword.ToString().Trim();
                    DBConnectString = sbDBConn.ToString().Trim();
                    DBSelection = sbDBSelection.ToString().Trim();
                    RoleStatement = sbRoleStatement.ToString().Trim();
                    SecLevel = sbSecLevel.ToString().Trim();
                }
                return true;
            }
            catch (Exception ex)
            {
                //Logger.Write(ex, TraceMask.Failure);
                throw ex;
            }
        }

        public static string VBLeftFunction(string value, int numberOfChar)
        {
            string temporaryString = value;
            if (value.Trim().Length >= numberOfChar)
            {
                temporaryString = value.Trim().Substring(0, numberOfChar);
            }
            else
            {
                temporaryString = value.Trim();
            }
            return temporaryString;
        }

        private static string DecodeReturnValue(int iValue, int iStatusCode)
        {
            string sMessage = string.Empty;
            switch (iValue)
            {
                case 2:
                    sMessage = "2 ~ Successful authentification.";
                    break;
                case 1:
                    sMessage = "1 ~ Successful authentification and user changed their password.";
                    break;
                case 0:
                    sMessage = "0 ~ User canceled the login process.";
                    break;
                case -1:
                    sMessage = "-1 ~ User failed on three login attempts.";
                    break;
                case -2:
                    sMessage = "-2 ~ Oracle error number: " + iStatusCode.ToString();
                    break;
                case -3:
                    sMessage = "-3 ~ No database or application INI file specified.";
                    break;
                case -4:
                    sMessage = "-4 ~ Could not find database entry in application INI file.";
                    break;
                case -5:
                    sMessage = "-5 ~ Error acessing specified application INI file.";
                    break;
                case -11:
                    sMessage = "-11 ~ Invalid User ID";
                    break;
                case -12:
                    sMessage = "-12 ~ Invalid password";
                    break;
                case -13:
                    sMessage = "-13 ~ Invalid database connect string";
                    break;
                case -14:
                    sMessage = "-14 ~ Invalid database selection string";
                    break;
                case -15:
                    sMessage = "-15 ~ Invalid INI filename string";
                    break;
                case -16:
                    sMessage = "-16 ~ Invalid Application name string";
                    break;
                case -111:
                    sMessage = "-111 ~ Oracle Request Application Role Info returned code\n"
                        + "Invalid database string";
                    break;
                case -112:
                    sMessage = "-112 ~ Oracle Request Application Role Info returned code\n"
                        + "Invalid application ID string";
                    break;
                case -113:
                    sMessage = "-113 ~ Oracle Request Application Role Info returned codes\n"
                        + "Invalid security level string";
                    break;
                case -201:
                    sMessage = "-201 ~ Oracle Get Next Application Role returned codes\n"
                        + "Application requesting this function is different from app which had last requested it.";
                    break;
                case -202:
                    sMessage = "-202 ~ Oracle Get Next Application Role returned codes\n"
                        + "Invaild application ID string.";
                    break;
            }
            return sMessage;
        }
    }
}
