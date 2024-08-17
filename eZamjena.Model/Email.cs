namespace Models
{
    public class Email
    {
        public string Subject { get; set; }
        public string EmailBody { get; set; }
        public string ReceiverEmail {  get; set; }
        public string SenderEmail {  get; set; }
        public string SenderName { get; set;}
        public string ReceiverName { get; set;}

    }
}
