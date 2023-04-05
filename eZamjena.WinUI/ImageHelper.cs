using System;
using System.Collections.Generic;
using System.Drawing.Imaging;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.WinUI
{
    public class ImageHelper
    {
        public static byte[]? FromImageToByte(Image? image)
        {
            if (image != null)
            {
                MemoryStream ms = new MemoryStream();
                image.Save(ms, ImageFormat.Jpeg);
                return ms.ToArray();
            }
            else
            {
                Bitmap emptyImage = new Bitmap(100, 100);
                Graphics g = Graphics.FromImage(emptyImage);
                g.Clear(Color.White);
                g.Dispose();
                MemoryStream ms = new MemoryStream();
                emptyImage.Save(ms, ImageFormat.Jpeg);
                return ms.ToArray();
            }
           // return null;
        }
        public static Image? FromByteToImage(byte[]? image)
        {
            if (image != null)
            {
                MemoryStream ms = new MemoryStream(image);
                return Image.FromStream(ms);
            }
            else
            {
                Bitmap emptyImage = new Bitmap(100, 100);
                Graphics g = Graphics.FromImage(emptyImage);
                g.Clear(Color.White);
                g.Dispose();
                return emptyImage;
            }
            //return null;
        }
    }
}
