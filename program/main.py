from tkinter import *
from tkinter import filedialog
import os
from PIL import ImageTk,Image
import requests
import subprocess


root = Tk()
root.title("Car service estimator")
main_frame = Frame(root)


dirname = os.path.dirname(__file__)

welcome_image_path = os.path.join(dirname, "welcome_image.jpeg")
selection_image_path = os.path.join(dirname, "page 2.jpeg")
bin_path = os.path.join(dirname, "bin", "car-exe")

welcome_image = Image.open(welcome_image_path).resize((400,400), Image.ANTIALIAS)

selection_image = Image.open(selection_image_path).resize((300,200), Image.ANTIALIAS)

user_chosen_filepaths = [] # initialise to empty

#pages variable of all the UI
count = 0


def get_photos(output_label):
    global user_chosen_filepaths
    if count == 1:
        filepaths = filedialog.askopenfilenames()
        user_chosen_filepaths = list(filepaths)
        if len(user_chosen_filepaths) > 0:
            call_api(output_label)
    

def call_api(output_label):
    global user_chosen_filepaths

    print("Calling API via binary " + bin_path + " with arguments " + ' '.join(user_chosen_filepaths))

    output = subprocess.check_output([bin_path] + user_chosen_filepaths)
    print(output)
    should_make_api_request = False
    output_utf8 = output.decode("utf-8")
    output_label.config(text=output_utf8)


# TODO: fix move page functions: it's very easy to click around and end up with
# an index out of bounds
def move_next_page(pages):
    global count

    if not count > len(pages)-2:
        for p in pages:
            p.pack_forget()

    count += 1
    # counts how many pages
    if count < 4:
        page = pages[count]
        page.pack(pady=100)


def move_back_page(pages):
    global count

    if not count == 0:

        for p in pages:
            p.pack_forget()

    count -= 1
    # counts how many pages
    if count > -1:
        page = pages[count]
        page.pack(pady=100)


#dimensions of the window 
window_width  = 750
window_height = 700

#getting the dimensions of the screen 
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()

#finding the center point 
center_x = int(screen_width/2 - window_width)
center_y = int(screen_height/2 - window_height)

#putting it in the center 
root.geometry(f'{window_width}x{window_height}+{center_x}+{center_y}')

#window is resizable 
root.resizable(0,0)

#welcome page 
page_1 = Frame(main_frame)
page_1_lb = Label(page_1, text='Welcome to remote Car service estimator', font=('Bold', 20),background = "yellow", borderwidth=3, relief="groove")
page_1_lb.pack()

welcome_tk_image = ImageTk.PhotoImage(welcome_image)
label = Label(page_1, image = welcome_tk_image)
label.pack(padx = 40)
page_1.pack(pady = 100)

#page to get output from haskell
# Note that this is defined before page_2 because we later modify page_3_l2 via page_2_l2
page_3 = Frame(main_frame)
page_3_l1 = Label(page_3, text='Output', font=('Bold', 20))
page_3_l1.pack()

page_3_l2 = Label(page_3, text = "", font = ("Bold",15 ) )
page_3_l2.pack()

#page to add inputs
page_2 = Frame(main_frame)
page_2_l1 = Label(page_2, text='Analysis phase', font=('Bold', 20),background = "cyan", borderwidth = 7, relief  = "ridge")
page_2_l1.pack(padx = 100, pady = 25)
page_2_l2 = Button(page_2, text="Input pictures", width=10, command=lambda: get_photos(page_3_l2))
page_2_l2.pack()
page_2_l3 = Label(page_2, text='Please input the pictures that you want to check', font=('Bold', 20), borderwidth = 3, relief = "sunken")
page_2_l3.pack()

selection_tk_image = ImageTk.PhotoImage(selection_image)
pic_photo2 = Label(page_2, image = selection_tk_image)
pic_photo2.pack()

#misc
page_4 = Frame(main_frame)
page_4_lb = Label(page_4, text='About', font=('Bold', 20))
page_4_lb.pack()

pages = [page_1, page_2, page_3, page_4]

main_frame.pack(fill=BOTH, expand=True)

bottom_frame = Frame(root)
# creating the back button 
back_btn = Button(bottom_frame, text='Back',
                     font=('Bold', 12),
                     bg='#1877f2', fg='blue', width=8,
                     command=lambda: move_back_page(pages))
back_btn.pack(side=LEFT, padx=10)

# creating the next button 
next_btn = Button(bottom_frame, text='Next',
                     font=('Bold', 12),
                     bg='#1877f2', fg='blue', width=8,
                     command=lambda: move_next_page(pages))
next_btn.pack(side=RIGHT, padx=10)

bottom_frame.pack(side=BOTTOM, pady=10)

root.mainloop()
