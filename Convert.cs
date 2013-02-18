using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.IO;

namespace GEDCOMtoXML
{

	public class Converter
	{
		static private bool IsTag(string val)
		{
			String[] tags = new string[]{ "_MILT","_MDCL","_HEIG","_WEIG","FAMC","FAMS","ASSO","RESN","NAME","AKA","SEX",
                                            "SUBM","ALIA","ANCI","DESI","RFN","AFN","REFN","RIN","CHAN","NOTE","SOUR","OBJE",
                                            "BIRT","CHR","DEAT","BURI","CREM","ADOP","BAPM","BARM","BASM","BLES","CHRA","CONF",
                                            "FCOM","ORDN","NATU","EMIG","IMMI","CENS","PROB","WILL","GRAD","RETI","EVEN",
                                            "CAST","DSCR","EDUC","IDNO","NATI","NCHI","NMR","OCCU","PROP","RELI","RESI","SSN",
                                            "TITL","FACT","ADDR","PHON","EMAIL","FAX","WWW","REFN", "TYPE", "HEAD", "CHAR", "VERS", "CORP",
                                            "GEDC", "FORM", "INDI", "DATE", "CHAR","SOUR","DEST","SUBM","SUBN","COPR","LANG","PLAC","DATE","NOTE",
                                            "DATA", "TEXT","PAGE","_APID","MARR","CONT", "CONC","_DEST", "_ORIG","FAM","AUTH","REPO", "PUBL","TRLR",
                                            "CHIL", "HUSB", "_FREL","WIFE","_MREL"};


			foreach (String t in tags)
				if (t == val)
					return true;

			return false;
		}

		static public void ConvertXML(string import_ged, string export_xml)
		{
			// doing with XML
			XmlDocument xmlDoc = new XmlDocument();
			XmlDeclaration xmlDeclaration = xmlDoc.CreateXmlDeclaration("1.0", "utf-8", null);
			XmlElement rootNode = xmlDoc.CreateElement("GEDCOM");
			xmlDoc.InsertBefore(xmlDeclaration, xmlDoc.DocumentElement);
			xmlDoc.AppendChild(rootNode);
			StreamReader sr = new StreamReader(import_ged);
			int prev_lvl = -1,
				cur_lvl = 0;
			XmlNode prevNode = rootNode;
			while (!sr.EndOfStream)
			{
				String line = sr.ReadLine();
				String[] elements = line.Split(' ');
				if (elements.Count() == 0)
					continue;

				cur_lvl = Convert.ToInt16(elements[0]);

				// find the id if present
				String id = "", tag = "", innerText = "";
				for (int i = 1; i < elements.Count(); ++i)
				{
					String element = elements[i];
					if (element.StartsWith("@"))
						id = element;
					else if (IsTag(element))
						tag = element;
					else
						innerText += element + " ";
				}

				if (tag.Length == 0)
				{
					Console.WriteLine(line);
					continue;
				}

				// create the new node
				XmlElement e = xmlDoc.CreateElement(tag);
				e.InnerText = innerText.Trim();
				XmlAttribute a = xmlDoc.CreateAttribute("level");
				a.InnerText = cur_lvl.ToString();
				e.Attributes.Append(a);
				if (id.Length > 0)
				{
					a = xmlDoc.CreateAttribute("id");
					a.InnerText = id;
					e.Attributes.Append(a);
				}

				if (cur_lvl == prev_lvl)
					prevNode.ParentNode.AppendChild(e);
				else if (cur_lvl > prev_lvl)
					prevNode.AppendChild(e);
				else
				{
					XmlNode pn = prevNode;
					for (int i = 0; i <= prev_lvl - cur_lvl; ++i)
						pn = pn.ParentNode;
					pn.AppendChild(e);
				}

				prevNode = e;
				prev_lvl = cur_lvl;
			}

			// run the transformation
			XslCompiledTransform xslTrans = new XslCompiledTransform();
			xslTrans.Load(@"GedTransform.xslt");

			if (!File.Exists(export_xml))
				File.Create(export_xml);

			XmlTextWriter xmlWriter = new XmlTextWriter(export_xml, null);
			xslTrans.Transform(xmlDoc, null, xmlWriter);
			xmlWriter.Close();
			sr.Close();
		}

	}
}
