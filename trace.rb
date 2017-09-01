require 'rubygems'
require 'mechanize'

def getPhoneNumber()
  puts("[!] Enter phone number [!]\n\n");
  phoneNumber = gets().to_s;
  return (phoneNumber);
end

def fbProfileGet(phoneNumber)
  agent = Mechanize.new;
  page = agent.get("https://www.facebook.com/login/identify");
  form = page.form_with(:id => "identify_yourself_flow");
  form["email"] = phoneNumber;
  button = form.button_with(:value => "Rechercher");
  page = agent.submit(form, button);
  puts(page.body);
end

def main()
  phoneNumber = getPhoneNumber();
  fbProfileGet(phoneNumber);
end

main();
