using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Calculator.ViewModel
{
    public class BaseViewModel:INotifyPropertyChanged
    {
        public BaseViewModel()
        {
            this.PropertyChanged += new PropertyChangedEventHandler(OnNotifiedOfPropertyChanged);
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(String propertyName)
        {
            if (this.PropertyChanged != null)
                this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
        }

        private void OnNotifiedOfPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (e != null && !String.Equals(e.PropertyName, "IsChanged", StringComparison.Ordinal))
            {
                this.IsChanged = true;
            }
        }

        private bool _notifyingObjectIsChanged;
        private readonly object _notifyingObjectIsChangedSyncRoot = new Object();
        [NotMapped]
        public bool IsChanged
        {
            get
            {
                lock (_notifyingObjectIsChangedSyncRoot)
                {
                    return _notifyingObjectIsChanged;
                }
            }

            set
            {
                lock (_notifyingObjectIsChangedSyncRoot)
                {
                    if (!Boolean.Equals(_notifyingObjectIsChanged, value))
                    {
                        _notifyingObjectIsChanged = value;

                        this.OnPropertyChanged("IsChanged");
                    }
                }
            }
        }
    }
}
