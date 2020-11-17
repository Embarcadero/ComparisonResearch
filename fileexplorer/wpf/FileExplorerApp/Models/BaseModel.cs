using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileExplorerApp.Models
{
    [Serializable]
    public abstract class BaseModel : INotifyPropertyChanged
    {

        private IDictionary<string, object> m_values = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);

        public T GetValue<T>(string key)
        {
            var value = GetValue(key);
            return (value is T) ? (T)value : default(T);
        }

        private object GetValue(string key)
        {
            if (string.IsNullOrEmpty(key))
            {
                return null;
            }
            return m_values.ContainsKey(key) ? m_values[key] : null;
        }

        public void SetValue(string key, object value)
        {
            if (!m_values.ContainsKey(key))
            {
                m_values.Add(key, value);
            }
            else
            {
                m_values[key] = value;
            }
            OnPropertyChanged(key);
        }


        [field: NonSerialized]
        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
